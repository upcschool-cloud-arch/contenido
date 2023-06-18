# ElastiCache: Redis

This laboratory creates a Redis cluster composed of one single node and an instance
on the same network to allow executing commands against it. To simplify everything,
Bash instructions are used instead of Terraform, and the resources will appear in the
default VPC of Virginia region.

Instructions should work fine both if you use the student workstation or CloudShell.

## Preparation

* Define the region for the commands

```bash
export AWS_DEFAULT_REGION=us-east-1
```

## Cluster creation

* Create the security group that will be used by the cluster node.

```bash
SG=$(aws ec2 create-security-group \
  --group-name redis-sg \
  --description "redis-sg" \
  --tag-specification "ResourceType=security-group,Tags=[{Key=Name,Value=redis-sg}]" \
  --query GroupId \
  --output text)
echo Security group: $SG
```

* Allow connection to the database port from anywhere (**obviously this extremely
permisive configuration is intended to be used during the lab**)

```bash
aws ec2 authorize-security-group-ingress \
  --group-id $SG \
  --protocol tcp \
  --port 6379 \
  --cidr 0.0.0.0/0 > /dev/null
echo Redis port opened in the security group.
```

* Launch the cluster. It will take several minutes to get it ready

```bash
aws elasticache create-cache-cluster \
    --cache-cluster-id "my-cluster" \
    --engine redis \
    --cache-node-type cache.t3.medium  \
    --num-cache-nodes 1 \
    --security-group-ids $SG
```

## Instance creation

* Find the id of the profile created by AWSAcademy. It will be used to assign
permissions to the operations instance. If you are running this lab in your own
account, you will need to create a *role* and an instance profile the name
`LabInstanceProfile` instead.

```bash
PROFILE=$(aws iam get-instance-profile \
  --instance-profile-name LabInstanceProfile \
  --query InstanceProfile.Arn \
  --output text)
```


* Start the instance

```bash
EC2=$(aws ec2 run-instances \
    --image-id ami-06a1f46caddb5669e \
    --instance-type t3.small \
    --iam-instance-profile  '{"Name": "LabInstanceProfile"}' \
    --query Instances[0].InstanceId \
    --output text)
echo Use session manager to connect to instance $EC2 using next link: https://us-east-1.console.aws.amazon.com/systems-manager/session-manager/$EC2?region=us-east-1.
```

## Testing the cluster

Wait until both the instance and the cluster are ready. Then, **use the link provided by the 
output of the last command to jump into the operations instance**. The next orders should
be executed there, as it is in the same network than the cluster and because of that we
can establish connectivity to it.

* Change from the SSM user to the ubuntu one

```bash
sudo su ubuntu
cd
```

* Install the `redis-cli` and `aws` tools

```bash
sudo apt update 
sudo apt-get install redis-tools awscli -y
```

* Find the DNS of the Redis node

```bash
REDIS=$(aws elasticache describe-cache-clusters \
  --cache-cluster-id my-cluster \
  --show-cache-node-info  \
  --query CacheClusters[0].CacheNodes[0].Endpoint.Address \
  --region us-east-1 \
  --output text)
echo Your cluster is at $REDIS.
```

* Check the connectivity to the server

```bash
redis-cli -h $REDIS -p 6379 PING
```

## Playing with the basic commands

Please, take some time to check the excellent [commands documentation](https://redis.io/commands/) to
learn about them. We are going to use only a small subset of the available orders.

* Set `100` as the value for the key `ALice` with a *TTL* of `60` seconds

```bash
redis-cli -h $REDIS -p 6379 SETEX Alice 60 100
```

* Get the value for the key `Alice`

```bash
redis-cli -h $REDIS -p 6379 GET Alice
```

* Get how many seconds remain until the value expires

```bash
redis-cli -h $REDIS -p 6379 TTL Alice
```

* Clean the database

```bash
redis-cli -h $REDIS -p 6379  flushall
```

* Add several elements to the `scores` set, each one with a different *weight*

```bash
redis-cli -h $REDIS -p 6379 ZADD scores 100 Alice
redis-cli -h $REDIS -p 6379 ZADD scores 75 Bob
redis-cli -h $REDIS -p 6379 ZADD scores 85 Charly
redis-cli -h $REDIS -p 6379 ZADD scores 30 David
```

* Ask for the top three elements of the `scores` set, ordered by weight

```bash
redis-cli -h $REDIS -p 6379 ZRANGE scores 0 2 REV WITHSCORES
```

* Get the position of the element with the key `David` on the set

```bash
redis-cli -h $REDIS -p 6379 ZREVRANK scores David
```

* Clean everything again

```bash
redis-cli -h $REDIS -p 6379 flushall
```

## Benchmarking

Redis includes a tool for testing the latency and performance of the server called
[redis-benchmark](https://redis.io/docs/management/optimization/benchmarks/). We will
use it to see how in many cases 99% of the requests takes less than 10ms even with such
a small cluster instance.

```bash
redis-benchmark -h $REDIS -p 6379 c
```

## Clean up

**Come back to your workstation or to the CloudShell service** to run the next commands.

* Shutdown the cluster

```bash
aws elasticache delete-cache-cluster \
  --cache-cluster-id "my-cluster" \
  --region us-east-1
```

* Delete the operations instance

```bash
aws ec2 terminate-instances --instance-ids $EC2
```