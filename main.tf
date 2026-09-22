terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}

# ------------------------------------------------------------
# Use the existing default VPC
# ------------------------------------------------------------
# The assignment requires using the default VPC and
# specifically says not to create a new VPC.
data "aws_vpc" "default" {
  default = true
}

# ------------------------------------------------------------
# Find Ubuntu 20.04 LTS AMI
# ------------------------------------------------------------
data "aws_ami" "ubuntu_20_04" {
  most_recent = true

  # Canonical Ubuntu AWS account
  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# ------------------------------------------------------------
# Security Group
# ------------------------------------------------------------
resource "aws_security_group" "nginx" {
  name        = "terraform-nginx-sg"
  description = "Allow HTTP and SSH access"
  vpc_id      = data.aws_vpc.default.id

  # Allow HTTP traffic
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH traffic
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "terraform-nginx-sg"
    Environment = "skill-test"
    ManagedBy   = "Terraform"
  }
}

# ------------------------------------------------------------
# EC2 Instance
# ------------------------------------------------------------
resource "aws_instance" "nginx" {
  ami           = data.aws_ami.ubuntu_20_04.id
  instance_type = var.instance_type

  # Attach the security group
  vpc_security_group_ids = [aws_security_group.nginx.id]

  # ----------------------------------------------------------
  # Install Nginx and create custom web page
  # ----------------------------------------------------------
  user_data = <<-EOF
    #!/bin/bash

    # Update package information
    apt-get update -y

    # Install Nginx
    apt-get install -y nginx

    # Replace the default Nginx index page
    cat > /var/www/html/index.html <<'HTML'
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <title>Terraform Nginx Server</title>
    </head>
    <body>
      <h1>Welcome to the Terraform-managed Nginx Server</h1>
      <p>on Ubuntu</p>
    </body>
    </html>
    HTML

    # Enable Nginx at boot
    systemctl enable nginx

    # Restart Nginx
    systemctl restart nginx
  EOF

  tags = {
    Name        = "terraform-nginx-server"
    Environment = "skill-test"
    ManagedBy   = "Terraform"
  }
}
