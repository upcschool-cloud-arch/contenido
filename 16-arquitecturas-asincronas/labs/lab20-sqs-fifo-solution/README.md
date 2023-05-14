# SQS FIFO queues

## Preparation

* Create the queue

```bash
aws sqs create-queue \
    --queue-name report-requests.fifo \
    --region us-east-1 \
    --attributes  "{\"FifoQueue\":\"true\"}"
```

## Producers

* Create the producer application, very similar to the previous lab one. But pay
attention to the use of `message-group-id` and `message-deduplication-id` 

```bash
cat << 'EOF' > producer.sh
#!/bin/sh

if [ $# -eq 0 ]; then
    echo "syntax: producer.sh NAME_OF_THE_PRODUCER"
    exit 1
fi

URL=$(aws sqs get-queue-url --queue-name report-requests.fifo --query QueueUrl --output text --region us-east-1)
echo Qeueu URL: $URL
for i in `seq 1 100`; do
  echo Producer $1 creating message $i.
  aws sqs send-message \
	  --queue-url $URL \
	  --message-body "This message was created by producer $1, with the number $i." \
      --message-group-id $1 \
      --message-deduplication-id $1_$i \
	  --region=us-east-1
  sleep 1
done
EOF

chmod +x producer.sh
```

* Launch two producers with different names (they will belong to different groups)

```bash
tmux split-window -l 8 bash producer.sh alpha; tmux last-pane
tmux split-window -l 8 bash producer.sh beta; tmux last-pane
```

## Consumer

* Write the consumer logic

```bash
cat << 'EOF' > consumer.sh
#!/bin/sh

if [ $# -eq 0 ]; then
    echo "syntax: producer.sh NAME_OF_THE_CONSUMER"
    exit 1
fi

URL=$(aws sqs get-queue-url --queue-name report-requests.fifo --query QueueUrl --output text --region us-east-1)
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
        echo "Consumer $1 is processing: $body"
        aws sqs delete-message --queue-url $URL --receipt-handle $handler --region us-east-1 
    else
        echo "No message received after 20 seconds."
    fi
done
EOF

chmod +x consumer.sh
```

* Launch one consumer and check how the order of the messages is kept

```bash
tmux split-window -l 8 bash consumer.sh uno; tmux last-pane
```

* Launch an additional producer **with the same `group id`* and see how its messages
don't appear, as they share an already used `deduplication id`

```bash
tmux split-window -l 8 bash producer.sh alpha; tmux last-pane
```

## Clean up

* Close all the secondary `tmux` panes

```bash
tmux kill-pane -a
```

* Delete the queue

```bash
URL=$(aws sqs get-queue-url --queue-name report-requests.fifo --query QueueUrl --output text --region us-east-1)
aws sqs delete-queue --queue-url $URL --region us-east-1
```