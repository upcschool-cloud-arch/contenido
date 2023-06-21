
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "instance-sg" {
  vpc_id = var.vpc

  dynamic "ingress" {
    for_each = var.tcp_allowed_ingress

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = format("%s-sg", var.name)
    account = "talks"
  }
}

resource "aws_instance" "instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet
  vpc_security_group_ids = [aws_security_group.instance-sg.id]

  user_data = <<EOF
#!/bin/bash
# User configuration
usermod -c ${var.system_user} -l ${var.system_user} -d /home/${var.system_user} -m ${var.system_default_user} && groupmod -n ${var.system_user} ${var.system_default_user};
echo "${var.system_user} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-cloud-init-users
curl -sq https://github.com/${var.github_user}.keys | tee -a /home/${var.system_user}/.ssh/authorized_keys
# Package installation
sudo apt update
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common jq docker.io cgroup-tools tree
usermod -aG docker ${var.system_user}
EOF

  tags = {
    Name    = var.name
    account = "talks"
  }
}
