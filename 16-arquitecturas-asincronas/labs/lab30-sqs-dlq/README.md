# SQS dead letter queues

## Preparation

* Create the *dead letter* queue

```bash
aws sqs create-queue --queue-name report-requests-dlq --region us-east-1

DLQ_URL=$(aws sqs get-queue-url \
   --queue-name report-requests-dlq \
   --query QueueUrl \
   --output text \
   --region us-east-1)
echo $DLQ_URL
```

* Get the dead letter queue *ARN* so we can reference it when creating the main one

```bash
DLQ_ARN=$(aws sqs get-queue-attributes \
  --queue-url $DLQ_URL \
  --attribute-names Q████Arn \
  --query Attributes.Q████Arn \
  --output text \
  --region us-east-1)
echo Dead letter queue URL: $DLQ_ARN
```

* Generate a dead letter queue policy for the main queue. Check the value of the
`maxReceiveCount` attribute, as it determines how many *lifes* do the messages have

```bash
cat << EOF > dlq-policy.json
{
  "RedrivePolicy": 
    "{\"deadLetterTargetArn\" : \"$DLQ_ARN\",\"maxReceiveCount\" : \"3\"}",
  "MessageRetentionPeriod": "$((60*60*8))"
}
EOF
```

* Now, let's create the main queue using that policy

```bash
aws sqs create-queue \
    --queue-name report-requests \
    --attr██████ file://dlq-policy.json \
    --region us-east-1

MAIN_URL=$(aws sqs get-queue-url \
   --queue-name report-requests \
   --query QueueUrl \
   --output text \
   --region us-east-1)
echo Main url: $MAIN_URL
```

## Producer

* It will be enough to generate ten messages and put them in the main queue to test this feature. In
this case, we just put a message number as its body

```bash
cat << 'EOF' > producer.sh
#!/bin/sh

URL=$(aws sqs get-queue-url --queue-name report-requests --query QueueUrl --output text --region us-east-1)
echo Qeueu URL: $URL
for i in `seq 1 10`; do
  echo Producer creating message $i.
  aws sqs send-message \
	  --queue-url $URL \
	  --message-body "$i" \
	  --region=us-east-1
done
EOF

chmod +x producer.sh

./producer.sh
```

## Main consumer

* This consumer will skip the deletion of every even message, so they will return to the
queue after the experitation of the *visibility timeout*, and eventually they will end on the
dead letter queue

```bash
cat << 'EOF' > consumer-main.sh
#!/bin/bash

URL=$(aws sqs get-queue-url --queue-name report-requests --query QueueUrl --output text --region us-east-1)
echo Queue url: $URL
while true; do
    msg=$(aws sqs receive-message \
            --queue-url $URL \
            --max-number-of-message 1 \
            --wait-time-seconds 20 \
            --attribute-names MessageGroupId \
            --region=us-east-1)
    if [ -n "$msg" ]; then
        handler=$(echo "$msg" | jq -r .Messages[0].ReceiptHandle)
        body=$(echo "$msg" | jq -r .Messages[0].Body)
        echo "Main consumer is processing: $body"
        if (($body % 2 == 1)); then 
            aws sqs delete-message --queue-url $URL --receipt-handle $handler --region us-east-1 
        else
            echo "Skipped message deletion for $body."; 
            continue; 
        fi    
    else
        echo "No message received after 20 seconds."
    fi
done
EOF

chmod +x consumer-main.sh
```

* Run the main consumer in another pane

```bash
tmux split-window -l 8 bash consumer-main.sh; tmux last-pane
```

## Dead letter queue consumer

* This consumer will just retreive the messages that appear in the dead letter queue. It will
take few minutes to get them there from the main one:

```bash
cat << 'EOF' > consumer-dlq.sh
#!/bin/bash

URL=$(aws sqs get-queue-url --queue-name report-requests-dlq --query QueueUrl --output text --region us-east-1)
echo Queue url: $URL
while true; do
    msg=$(aws sqs receive-message \
            --queue-url $URL \
            --max-number-of-message 1 \
            --wait-time-seconds 20 \
            --attribute-names MessageGroupId \
            --region=us-east-1)
    if [ -n "$msg" ]; then
        handler=$(echo "$msg" | jq -r .Messages[0].ReceiptHandle)
        body=$(echo "$msg" | jq -r .Messages[0].Body)
        echo "DLQ consumer is processing: $body"
        aws sqs delete-message --queue-url $URL --receipt-handle $handler --region us-east-1 
    else
        echo "No message received after 20 seconds."
    fi
done
EOF

chmod +x consumer-dlq.sh
```

* Run this other consumer on its own pane:

```bash
tmux split-window -l 8 bash consumer-dlq.sh; tmux last-pane
```

## Clean up

* Close all the secondary `tmux` panes

```bash
tmux kill-pane -a
```

* Delete the queues

```bash
URL=$(aws sqs get-queue-url --queue-name report-requests --query QueueUrl --output text --region us-east-1)
aws sqs delete-queue --queue-url $URL --region us-east-1

URL=$(aws sqs get-queue-url --queue-name report-requests-dlq --query QueueUrl --output text --region us-east-1)
aws sqs delete-queue --queue-url $URL --region us-east-1
```