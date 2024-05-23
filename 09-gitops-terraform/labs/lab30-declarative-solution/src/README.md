# Lab30 - Declarative - Solution

Why does the apply fails whenever trying to change the VPC CIDR?

```bash
terraform apply -var vpc-cidr=10.1.0.0/16
```

There is a deadlock, modifying the VPC CIDR forces the whole VPC to be replaced, but the IGW VPC id can be changed without replacing the resource itself. But! The vpc cannot be deleted if the IGW is still attached... So we need to force it

```bash
terraform apply -var vpc-cidr=10.1.0.0/16 -replace aws_internet_gateway.igw
```