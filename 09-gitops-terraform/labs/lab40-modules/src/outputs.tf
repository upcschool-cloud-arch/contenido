output "vpc_id" {
  description = "The id of the VPC created by the module."
  value = module.simple_vpc.vpc_id
}
