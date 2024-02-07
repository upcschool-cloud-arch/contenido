provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

module "vpc" {
  source = "./modules/vpc"
  name   = "eks"
}

data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

data "aws_key_pair" "lab" {
  key_name           = "vockey"
  include_public_key = true
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.1.0"

  cluster_name    = "test-1"
  cluster_version = "1.29"

  # IAM

  create_iam_role = false
  iam_role_arn    = data.aws_iam_role.lab_role.arn
  enable_irsa     = false

  # Encryption

  # Networking

  cluster_endpoint_public_access = true

  vpc_id = module.vpc.vpc_id

  subnet_ids = [
    module.vpc.public_subnet_a,
    module.vpc.public_subnet_b,
    module.vpc.public_subnet_c
  ]

  control_plane_subnet_ids = [
    module.vpc.private_subnet_a,
    module.vpc.private_subnet_b,
    module.vpc.private_subnet_c
  ]

  # Addons

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium", "t3.large"]
  }

  eks_managed_node_groups = {
    lab = {
      min_size     = 1
      max_size     = 4
      desired_size = 1

      instance_types = ["t3.medium"]

      ec2_ssh_key = data.aws_key_pair.lab.arn

      create_iam_role = false
      iam_role_arn    = data.aws_iam_role.lab_role.arn
    }
  }

  tags = {
    Environment = "lab"
    Terraform   = "true"
  }
}

output "aws-eks-kubeconfig-cmd" {
  value = format("%s --name %s --region %s",
    "aws eks update-kubeconfig",
    module.eks.cluster_name,
    data.aws_region.current.id
  )
}
