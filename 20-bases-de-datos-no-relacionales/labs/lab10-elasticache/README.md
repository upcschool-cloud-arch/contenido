export AWS_DEFAULT_REGION=us-east-1

SG=$(aws ec2 create-security-group \
  --group-name redis-sg \
  --description "redis-sg" \
  --tag-specification "ResourceType=security-group,Tags=[{Key=Name,Value=redis-sg}]" \
  --query GroupId \
  --output text)
echo Security group: $SG

aws ec2 authorize-security-group-ingress \
  --group-id $SG \
  --protocol tcp \
  --port 6379 \
  --cidr 0.0.0.0/0 > /dev/null
echo Redis port opened in the security group.

aws elasticache create-cache-cluster \
    --cache-cluster-id "my-cluster" \
    --engine redis \
    --cache-node-type cache.t3.medium  \
    --num-cache-nodes 1 \
    --security-group-ids $SG

PROFILE=$(aws iam get-instance-profile \
  --instance-profile-name LabInstanceProfile \
  --query InstanceProfile.Arn \
  --output text)

aws ec2 run-instances \
    --image-id ami-06a1f46caddb5669e \
    --instance-type t2.micro \
    --iam-instance-profile  '{"Name": "LabInstanceProfile" }'

Connect to the new instance

sudo su ubuntu
cd

sudo apt update 
sudo apt-get install redis-tools awscli -y

REDIS=$(aws elasticache describe-cache-clusters \
  --cache-cluster-id my-cluster \
  --show-cache-node-info  \
  --query CacheClusters[0].CacheNodes[0].Endpoint.Address \
  --region us-east-1 \
  --output text)
echo Your cluster is at $REDIS.

redis-cli -h $REDIS -p 6379 PING
