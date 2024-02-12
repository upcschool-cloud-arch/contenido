# Notes

## 0. Create the stack in AWS (Terminal 1)

https://us-east-1.console.aws.amazon.com/ec2/v2/home?region=us-east-1#Instances:instanceState=running

```
tf init && tf apply --var "github_user=YOUR_GH_USER_ID"
```

The instance doesn't uses the LabRole instance profile to avoid TLS issues with EKS.

## 1. Clone the repo

```
git clone --depth 1 --branch feat/update-k8s-content git@github.com:upcschool-cloud-arch/contenido.git
```

## 2. Configure AWS credentials

https://awsacademy.instructure.com/courses/64811/modules/items/5739658

```
aws configure set region us-east-1 && nano ~/.aws/credentials
```
