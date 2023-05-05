terraform {
  required_version = ">= 0.15"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "replica"
  region = var.replica_region
}

module "remote_state" {
  source  = "nozaq/remote-state-s3-backend/aws"
  version = "1.5.0"
  
  override_s3_bucket_name = true
  s3_bucket_name          = "my-fixed-bucket-name-remote-state"
  s3_bucket_name_replica  = "my-fixed-bucket-replica-name-remote-state"

  terraform_iam_policy_create = false

  providers = {
    aws         = aws
    aws.replica = aws.replica
  }
}

