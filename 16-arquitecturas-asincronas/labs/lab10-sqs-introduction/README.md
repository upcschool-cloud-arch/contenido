# Introduction to SQS

*Note*: The laboratories of this topic are much more interesting if different people of the team assume different
roles as producers and consumers, by sharing a single queue.

## Preparation

* Create the queue

```bash
aws sqs create-queue --queue-name report-requests --region us-east-1
```

* Check the url of the queue

```bash
URL=$(aws sqs get-queue-url --queue-name report-requests --query QueueUrl --output text --region us-east-1)
echo $URL
```

* Take a first look at the main queue metrics

```bash
aws sqs get-queue-attributes --queue-url $URL --attribute-names All --region us-east-1
```

* Keep an eye on those metrics in a separated panel

```bash
URL=$(aws sqs get-queue-url --queue-name report-requests --query QueueUrl --output text --region us-east-1)
tmux split-window -l 18 \
    watch aws sqs get-queue-attributes --queue-url $URL --attribute-names All --region us-east-1; tmux last-pane
```

## Producers

* Create the producer application. Each instance will put a message in the queue each second

```bash
cat << 'EOF' > producer.sh
#!/bin/sh

if [ $# -eq 0 ]; then
    echo "syntax: producer.sh NAME_OF_THE_PRODUCER"
    exit 1
fi

URL=$(aws sqs get-queue-url --queue-name report-requests --query QueueUrl --output text --region us-east-1)
echo Qeueu URL: $URL
for i in `seq 1 100`; do
  echo Producer $1 creating message $i.
  aws sqs send-message \
	  --queue-url $URL \
	  --message-body "This message was created by producer $1, with the number $i." \
	  --region=us-east-1
  sleep 1
done
EOF

chmod +x producer.sh
```

* Start *at least* one producer in a different pane

```bash
tmux split-window -h bash producer.sh alpha; tmux last-pane
```

## Consumer

* Pick up a message of the queue to understand the format

```
URL=$(aws sqs get-queue-url --queue-name report-requests --query QueueUrl --output text --region us-east-1)
aws sqs receive-message \
	     --queue-url $URL \
	     --max-number-of-message 1 \
	     --region=us-east-1 \
| jq
```

* Write the consumer logic. We simulate the asimetric situation by making it slower than the producer:

```bash
cat << 'EOF' > consumer.sh
#!/bin/sh

if [ $# -eq 0 ]; then
    echo "syntax: producer.sh NAME_OF_THE_CONSUMER"
    exit 1
fi

URL=$(aws sqs get-queue-url --queue-name report-requests --query QueueUrl --output text --region us-east-1)
echo Queue url: $URL
while true; do
    msg=$(aws sqs receive-message \
            --queue-url $URL \
            --max-number-of-message 1 \
            --region=us-east-1)
    handler=$(echo "$msg" | jq -r .Messages[0].ReceiptHandle)
    body=$(echo "$msg" | jq -r .Messages[0].Body)
    echo "$body"
    sleep 2
    aws sqs delete-message --queue-url $URL --receipt-handle $handler --region us-east-1 
done
EOF

chmod +x consumer.sh
```

* Launch three consumers, competing for the messages

```bash
tmux split-window -l 4 bash consumer.sh alpha; tmux last-pane
tmux split-window -l 4 bash consumer.sh alpha; tmux last-pane
tmux split-window -l 4 bash consumer.sh alpha; tmux last-pane
```

## Metrics

* Check how the *ApproximateNumberOfMessages* and *ApproximateNumberOfMessagesNotVisible* evolves

## Clean up

* Close all the secondary `tmux` panes

```bash
kill-pane -a -t 0
```

* Delete the queue

```bash
URL=$(aws sqs get-queue-url --queue-name report-requests --query QueueUrl --output text --region us-east-1)
aws sqs delete-queue --queue-url $URL --region us-east-1
```