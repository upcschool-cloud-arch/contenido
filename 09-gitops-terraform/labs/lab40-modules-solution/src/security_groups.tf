# Load Balancer Security Group
resource "aws_security_group" "load_balancer_sg" {
  name        = "load_balancer_sg"
  description = "Security group for load balancers"
  vpc_id      = module.vpc.default_vpc_id

  # Allow access from internet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow exit
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Web Server Security Group
resource "aws_security_group" "web_server_sg" {
  name        = "web_server_sg"
  description = "Security group for web servers"
  vpc_id      = module.vpc.default_vpc_id

  # Allow ingress from load balancer
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  # Allow egress to internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# PostgreSQL Database Security Group
resource "aws_security_group" "postgres_sg" {
  name        = "postgres_sg"
  description = "Security group for PostgreSQL databases"
  vpc_id      = module.vpc.default_vpc_id

  # Allow ingress from webserver
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.web_server_sg.id]
  }

  # Allow egress to internet for update
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
