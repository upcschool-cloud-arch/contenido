variable "owner" {
  description = "Owner of the created resources"
  type        = string
  default     = "matrix"
}

variable "region" {
  description = "Region"
  type        = string
  default     = "us-east-1" 
}

variable "environment" {
  description = "The current environment"
  type        = string
  default     = "dev"
}

variable "vpc-cidr" {
  description = "The address range of the VPC"
  type        = string
  default     = "10.0.0.0/16"
}