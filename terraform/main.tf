provider "aws" {
  region = var.aws_region
}

# Get latest Ubuntu 22.04 AMI dynamically
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group
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

# Generate new SSH key pair
resource "tls_private_key" "devops_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "devops_key" {
  key_name   = "devops-tf-key"
  public_key = tls_private_key.devops_key.public_key_openssh
}

# Save private key locally for Ansible
resource "local_file" "devops_private_key" {
  content         = tls_private_key.devops_key.private_key_pem
  filename        = "${path.module}/devops-tf-key.pem"
  file_permission = "0400"
}

# EC2 Instance
resource "aws_instance" "devops_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.devops_key.key_name
  security_groups = [aws_security_group.devops_sg.name]

  tags = {
    Name = "devops-server"
  }
}
