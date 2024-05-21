module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"
  cidr = var.vpc-cidr
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = cidrsubnets(cidrsubnet(var.vpc-cidr, 4, 0), 4, 4, 4) # Default -> "10.0.0.0/24","10.0.1.0/24","10.0.2.0/24"
  public_subnets = cidrsubnets(cidrsubnet(var.vpc-cidr, 4, 8), 4, 4, 4)  # Default -> "10.0.128.0/24","10.0.129.0/24","10.0.130.0/24" 
  enable_nat_gateway = false # No nos queremos quedar pobres aún!
  tags = {
    Owner = var.owner
    Name = "${var.owner}-vpc"
    Environment = var.environment
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}