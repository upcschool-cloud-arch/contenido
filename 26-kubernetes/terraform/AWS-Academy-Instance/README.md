# Notes

## 0. Create the stack in AWS (Terminal 1)

https://us-east-1.console.aws.amazon.com/ec2/v2/home?region=us-east-1#Instances:instanceState=running

Export your Github user ID, this will use to fetch your public SSH keys from Github.

```sh
export GITHUB_USER_ID=raelga
```

Apply the terraform stack:

```sh
terraform init && terraform apply --var "github_user=${GITHUB_USER_ID}"
```

The instance doesn't uses the LabRole instance profile to avoid TLS issues with EKS.

## 1. Clone the repo

```sh
git clone --depth 1 git@github.com:raelga/kubernetes-talks.git
```

If you don't have SSH access to GitHub, use this:

```sh
git clone --depth 1 https://github.com/upcschool-cloud-arch/contenido.git
```

## 2. Configure AWS credentials

https://awsacademy.instructure.com/courses/64811/modules/items/5739658

```sh
aws configure set region us-east-1 && nano ~/.aws/credentials
```

Check current user:

```sh
aws sts get-caller-identity
```

Should look something like:

```
{
    "UserId": "AROAW3MEAMOJIMMRJS4E4:user3043538=Rael_Garcia",
    "Account": "41231231234",
    "Arn": "arn:aws:sts::41231231234:assumed-role/voclabs/user3043538=Rael_Garcia"
}
```
