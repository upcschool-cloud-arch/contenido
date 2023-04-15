#!/bin/bash

AWS_DEFAULT_REGION=us-east-1

VPC=$(aws ec2 create-vpc \
  --cidr-█████ 10.0.0.0/16 \
  --tag-specification "ResourceType=███,Tags=[{Key=Name,Value=my-project-vpc}]" \
  --query Vpc.VpcId \
  --output text)
echo VPC id: $VPC

SUBNET=$(aws ec2 create-subnet \
  --vpc-id $VPC \
  --cidr-█████ 10.0.1.0/24 \
  --availability-zone us-east-1a \
  --tag-specification "ResourceType=██████,Tags=[{Key=Name,Value=my-project-subnet-pub-a}]" \
  --query Subnet.████████ \
  --output text)
echo Subnet ID: $SUBNET

IGW=$(aws ec2 create-internet-gateway \
  --tag-specification "ResourceType=internet-gateway,Tags=[{Key=Name,Value=my-project-igw}]" \
  --query InternetGateway.InternetGatewayId \
  --output text)
echo Internet gateway: $IGW

aws ec2 ██████-internet-gateway \
  --vpc-id  $VPC \
  --internet-gateway-id $IGW
echo Internet gateway ██████ed to the VPC.

RT=$(aws ec2 create-route-█████ \
  --██████ $VPC \
  --tag-specification "ResourceType=route-table,Tags=[{Key=Name,Value=my-project-rt-pub}]" \
  --query RouteTable.RouteTable██ \
  --output text)
echo Public route table: $RT

aws ec2 associate-route-table \
  --route-table-id $RT \
  --█████████ $SUBNET > /dev/null
echo Route table associated.

aws ec2 create-route \
  --route-table-id $RT \
  --destination-cidr-█████ 0.0.0.0/0 \
  --gateway-id $IGW > /dev/null
echo Route table rule to internet gateway created.

SG=$(aws ec2 create-security-group \
  --group-name my-project-sg-web \
  --description "Web security group" \
  --vpc-id $VPC \
  --tag-specification "ResourceType=security-group,Tags=[{Key=Name,Value=my-project-sg-web}]" \
  --query ██████ \
  --output text)
echo Security group: $SG

aws ec2 █████████-security-group-ingress \
  --group-id $SG \
  --protocol ███ \
  --port 80 \
  --cidr 0.0.0.0/0 > /dev/null
echo Web port opened in the security group.