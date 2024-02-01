provider "aws" {
  region = "us-east-1"
}

data "aws_region" "current" {}

data "aws_vpc" "default" {
  default = true
}

# resource "aws_default_subnet" "default" {
#   availability_zone = format("%sa", data.aws_region.current.id)
# }
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_subnet" "default" {
  for_each = toset(data.aws_subnets.default.ids)
  id       = each.value
}

variable "github_user" {
  description = "GitHub user ID for system account creation and SSH keys"
  type        = string
  default     = "raelga"
}

module "ec2" {
  source              = "./terraform/modules/aws/ec2-academy/instance"
  name                = "containers-lab"
  vpc                 = data.aws_vpc.default.id
  subnet              = data.aws_subnets.default.ids[0]
  system_user         = var.github_user
  github_user         = var.github_user
  instance_type       = "t3a.large"
  tcp_allowed_ingress = [22, 80, 81]
}

# module "ec2" {
#   source              = "./terraform/modules/aws/ec2/spot-instance"
#   name                = "scratch"
#   vpc                 = module.vpc.vpc_id
#   subnet              = module.vpc.subnet_az1_id
#   system_user         = "rael"
#   github_user         = "raelga"
#   instance_type       = "t3a.2xlarge"
#   spot_price          = "0.10"
#   tcp_allowed_ingress = [22, 80]
# }

output "username" {
  value = module.ec2.username
}

output "public_ip" {
  value = module.ec2.public_ip
}

output "ssh_cmd" {
  value = module.ec2.ssh_cmd
}