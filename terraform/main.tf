provider "aws" {
  region = var.aws_region
}

# Get latest Ubuntu 22.04 AMI dynamically from Canonical
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "devops_sg" {
  name = "devops_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "devops_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "devops-automation"
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  tags = {
    Name = "DevOps-Automation-Server"
  }
}

# Automatically generate Ansible inventory file
resource "local_file" "ansible_inventory" {
  content = <<EOF
[web]
${aws_instance.devops_instance.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/devops-automation.pem
EOF

  filename = "../ansible/inventory.ini"
}
