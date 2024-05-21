variable "owner" {
  description = "Owner of the created resources"
  type        = string
  default     = "matrix"
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