output "vpc_id" {
  description = "The id of the VPC."
  value = module.vpc.default_vpc_id
}

output "sg_group_load_balancer_id" {
  description = "The id of load balancer sg"
  value = aws_security_group.load_balancer_sg.id
}

output "sg_web_server_id" {
  description = "The id of webserver sg"
  value = aws_security_group.web_server_sg.id
}

output "sg_postgresql_id" {
  description = "The id of postgresql sg"
  value = aws_security_group.postgres_sg.id
}