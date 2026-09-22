
# Terraform-Managed Nginx Server on Ubuntu

> AWS Infrastructure as Code (IaC) project using Terraform to provision an Ubuntu 20.04 LTS EC2 instance running Nginx.

---

##  Project Overview

This project demonstrates the use of **Terraform Infrastructure as Code (IaC)** to provision and manage an AWS EC2 instance running **Nginx on Ubuntu 20.04 LTS**.

The infrastructure is deployed using the **existing AWS default VPC**.

The Terraform configuration does **not** create a separate:

* VPC
* Subnet
* Internet Gateway

Terraform creates only the resources required for the deployment:

* EC2 instance
* Security Group

The EC2 instance is automatically configured using Terraform `user_data` to:

1. Install Nginx
2. Replace the default Nginx web page
3. Create the required custom HTML page
4. Enable Nginx at system startup
5. Restart Nginx

---

##  Assignment Objectives

The project implements the following requirements:

* Configure the AWS provider and region
* Use the existing default VPC
* Launch an Ubuntu 20.04 LTS EC2 instance
* Use a `t2.micro` instance
* Configure HTTP access on port `80`
* Configure SSH access on port `22`
* Install Nginx using EC2 `user_data`
* Replace the default Nginx page
* Create the required custom HTML page
* Output the EC2 public IP
* Support infrastructure teardown using `terraform destroy`
* Document the implementation and deployment process
* Store the project in a GitHub repository

---

##  Architecture

```
AWS
 │
 ▼
┌──────────────────────────────┐
│        Existing Default      │
│             VPC              │
│                              │
│        172.31.0.0/16         │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│      Terraform Security      │
│           Group              │
│                              │
│   HTTP  → TCP 80             │
│   SSH   → TCP 22             │
│   Outbound → All             │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│          EC2 Instance        │
│                              │
│      Ubuntu 20.04 LTS        │
│           t2.micro           │
│                              │
│            Nginx             │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│       Custom Web Page        │
│                              │
│ Welcome to the              │
│ Terraform-managed Nginx      │
│ Server                       │
│                              │
│ on Ubuntu                    │
└──────────────────────────────┘
```

---

## ☁️ AWS Environment

### AWS Region

`ap-south-1`

The project is deployed in the AWS Mumbai region.

### Default VPC

The existing AWS default VPC is used.

Example:

| Property | Value                   |
| -------- | ----------------------- |
| VPC      | `vpc-0e495284b44210b54` |
| CIDR     | `172.31.0.0/16`         |

The default VPC is discovered dynamically using Terraform:

```
data "aws_vpc" "default" {
  default = true
}
```

No new VPC is created.

---

##  EC2 Configuration

| Configuration    | Value            |
| ---------------- | ---------------- |
| Operating System | Ubuntu 20.04 LTS |
| Instance Type    | `t2.micro`       |
| AWS Region       | `ap-south-1`     |
| Architecture     | `x86_64`         |
| Web Server       | Nginx            |
| HTTP Port        | `80`             |
| SSH Port         | `22`             |

The Ubuntu AMI is discovered dynamically using Terraform instead of permanently hardcoding an AMI ID.

---

##  Security Group

Terraform creates a Security Group named:

`terraform-nginx-sg`

### Inbound Rules

| Protocol | Port | Source      | Purpose |
| -------- | ---: | ----------- | ------- |
| TCP      |   80 | `0.0.0.0/0` | HTTP    |
| TCP      |   22 | `0.0.0.0/0` | SSH     |

### Outbound Rules

All outbound traffic is allowed.

`0.0.0.0/0`

### Security Note

SSH access is open to the internet for this skill-test deployment.

For production environments, SSH access should normally be restricted to trusted IP addresses, VPN access, or an appropriate AWS management mechanism.

---

## 📦 AWS Resources

### Resources Created by Terraform

#### EC2 Instance

Terraform resource:

`aws_instance.nginx`

Configuration:

* Ubuntu 20.04 LTS
* `t2.micro`
* Nginx

#### Security Group

Terraform resource:

`aws_security_group.nginx`

Provides:

* HTTP — TCP port `80`
* SSH — TCP port `22`

---

## ♻️ Existing AWS Resources Used

The following existing AWS resources are used by the deployment:

* Default VPC
* Default subnet
* Internet Gateway associated with the default VPC

These resources are **not created by Terraform**.

This is intentional because the assignment requires the existing default VPC to be used.

---

##  Project Structure

```
terraform-nginx-ubuntu/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── README.md
├── .gitignore
└── .terraform.lock.hcl

```
<img width="1919" height="179" alt="image" src="https://github.com/user-attachments/assets/7e832f77-58e3-442c-b408-e597e627547c" />


### File Description

| File                  | Description                                                             |
| --------------------- | ----------------------------------------------------------------------- |
| `main.tf`             | Main Terraform configuration                                            |
| `variables.tf`        | Terraform input variables                                               |
| `outputs.tf`          | Terraform output values                                                 |
| `README.md`           | Project documentation                                                   |
| `.gitignore`          | Prevents Terraform state and sensitive/local files from being committed |
| `.terraform.lock.hcl` | Locks the Terraform provider version                                    |

---

##  Technologies Used

* Terraform
* AWS EC2
* AWS VPC
* AWS Security Groups
* AWS CLI
* Ubuntu 20.04 LTS
* Nginx
* Git
* GitHub
* WSL

---

## 🛠️ Prerequisites

Before running this project, install:

* AWS account
* IAM user with appropriate permissions
* AWS CLI
* Terraform CLI
* Git
* WSL or Linux environment

Verify Terraform:

```
terraform version
```
<img width="1918" height="110" alt="image" src="https://github.com/user-attachments/assets/a842aa70-65b7-48fd-a347-a1f1746b9bb6" />



Verify AWS CLI:

```
aws --version
```
<img width="1919" height="57" alt="image" src="https://github.com/user-attachments/assets/9589c768-89ba-48f4-91d4-0a07d22a95fd" />

Verify Git:

```
git --version
```
<img width="1912" height="46" alt="image" src="https://github.com/user-attachments/assets/d0a77dc1-7f21-4221-be7a-5b2e0c4c6200" />

---

##  AWS IAM Requirements

The AWS IAM identity used by Terraform requires sufficient permissions to:

* Read VPC information
* Read AMI information
* Create EC2 instances
* Create Security Groups
* Delete EC2 instances
* Delete Security Groups

AWS credentials should be configured using the AWS CLI.

---

##  AWS CLI Configuration

Configure AWS CLI:

```
aws configure
```

The CLI will request:

* AWS Access Key ID
* AWS Secret Access Key
* Default region name
* Default output format

Example region:

`ap-south-1`

Example output format:

`json`

Verify AWS authentication:

```
aws sts get-caller-identity
```

Verify the configured region:

```
aws configure get region
```

Expected:

`ap-south-1`

>  Never commit AWS Access Keys, Secret Keys, passwords, or other credentials to GitHub.

---

##  Terraform Configuration

### Provider Configuration

The project uses the official HashiCorp AWS provider.

```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.5.0"
}
```

The AWS region is configured through a Terraform variable:

```
provider "aws" {
  region = var.aws_region
}
```

---

## ⚙️ Terraform Variables

The project defines the following variables:

```
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
```

This allows the AWS region and EC2 instance type to be changed without modifying the main infrastructure configuration.

---

##  Default VPC Lookup

The existing default VPC is discovered using:

```
data "aws_vpc" "default" {
  default = true
}
```

This ensures Terraform does not create a new VPC.

---

## 🐧 Ubuntu 20.04 AMI Lookup

Terraform dynamically searches for an available Ubuntu 20.04 LTS AMD64 AMI:

```
data "aws_ami" "ubuntu_20_04" {
  most_recent = true

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
```

This avoids permanently hardcoding a region-specific AMI ID.

---

##  Security Group Configuration

The Terraform configuration creates the Security Group:

```
resource "aws_security_group" "nginx" {
  name        = "terraform-nginx-sg"
  description = "Allow HTTP and SSH access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
```

---

##  EC2 Configuration

The EC2 instance is created using:

```
resource "aws_instance" "nginx" {
  ami           = data.aws_ami.ubuntu_20_04.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.nginx.id]
}
```

The EC2 instance uses the dynamically discovered Ubuntu 20.04 AMI and the configured `t2.micro` instance type.

---

##  Nginx Installation Using User Data

The EC2 instance uses Terraform `user_data` to automatically configure Nginx during the initial boot.

```
#!/bin/bash

apt-get update -y

apt-get install -y nginx

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

systemctl enable nginx

systemctl restart nginx
```

---

##  Nginx Deployment Flow

```
EC2 Instance Created
        │
        ▼
Ubuntu 20.04 Boots
        │
        ▼
User Data Executes
        │
        ▼
apt-get update
        │
        ▼
Nginx Installed
        │
        ▼
Default index.html Replaced
        │
        ▼
Nginx Enabled at Boot
        │
        ▼
Nginx Restarted
        │
        ▼
Port 80 Available
        │
        ▼
Custom Web Page Served
```

---

##  Custom Web Page

The default Nginx page is replaced with the required content:

> Welcome to the Terraform-managed Nginx Server

> on Ubuntu

The HTML file is located at:

`/var/www/html/index.html`

---

##  Deployment Process

### Step 1 — Clone the Repository

```
git clone https://github.com/Mithunvm92/terraform-nginx-ubuntu.git
```

Enter the project directory:

```
cd terraform-nginx-ubuntu
```

---

### Step 2 — Initialize Terraform

Run:

```
terraform init
```

Terraform downloads the required AWS provider.

Expected result:

```
Terraform has been successfully initialized!
```

---

### Step 3 — Format Terraform Files

Run:

```
terraform fmt
```

This formats Terraform configuration files according to Terraform formatting standards.

---

### Step 4 — Validate Configuration

Run:

```
terraform validate
<img width="1919" height="59" alt="image" src="https://github.com/user-attachments/assets/a0881548-db86-42d6-b510-7ff783e6f26d" />

```

Expected result:

```
Success! The configuration is valid.
```

---

### Step 5 — Review Terraform Plan

Run:

```
terraform plan
```

The plan should identify the resources that Terraform will create.

Expected resource types:

* `aws_security_group.nginx`
* `aws_instance.nginx`

Expected summary:
<img width="1915" height="214" alt="image" src="https://github.com/user-attachments/assets/6eba9b79-7aed-4374-82d6-312145372042" />

```
Plan: 2 to add, 0 to change, 0 to destroy.
```

Terraform also evaluates these data sources:

* `data.aws_ami.ubuntu_20_04`
* `data.aws_vpc.default`

Data sources are used for lookups and do not create AWS infrastructure.

---

### Step 6 — Deploy Infrastructure

Run:

```
terraform apply
```

Terraform will display the planned changes and request confirmation.

Enter:

```
yes
```

Terraform creates:

* 1 × Security Group
* 1 × EC2 Instance

Expected result:

```
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

Terraform also displays the EC2 public IP:

```
instance_public_ip = "<PUBLIC_IP>"

```
<img width="1919" height="323" alt="image" src="https://github.com/user-attachments/assets/ab2e9b0c-0cfe-4f14-b2da-d0f20accd525" />

---

##  Terraform Output

Retrieve the public IP:

```
terraform output instance_public_ip
```

Example:

```
15.206.209.201
```

> The public IP may change if the EC2 instance is destroyed and recreated.

---

##  Access the Nginx Server

After deployment, open the following URL in a web browser:

```
http://<PUBLIC_IP>
```

Example:

```
http://15.206.209.201
```

The browser should display:

> Welcome to the Terraform-managed Nginx Server

> on Ubuntu

---

## 🧪 Command-Line Verification

Test the web page:

```
curl http://<PUBLIC_IP>

```
<img width="1919" height="103" alt="image" src="https://github.com/user-attachments/assets/3f48e9ad-b58b-457d-9f55-df8ff343bd86" />

Test the HTTP response headers:

```
curl -I http://<PUBLIC_IP>
```

Expected response:

```
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)
Content-Type: text/html
```

A successful `HTTP/1.1 200 OK` confirms that:

* The EC2 instance is reachable
* HTTP port 80 is accessible
* Nginx is running
* The web server is responding

---

## 🔍 Terraform State Verification

List Terraform-managed resources:

```
terraform state list
```

Expected output:

```
data.aws_ami.ubuntu_20_04
data.aws_vpc.default
aws_instance.nginx
aws_security_group.nginx


```
<img width="1917" height="114" alt="image" src="https://github.com/user-attachments/assets/7ba10b11-ef90-4e2a-a29b-ab11ab814c8f" />
<img width="1688" height="361" alt="image" src="https://github.com/user-attachments/assets/2712ca05-6759-4e23-ba2f-5c7826ddfac4" />


The actual AWS resources created by Terraform are:

* `aws_instance.nginx`
* `aws_security_group.nginx`

The following are Terraform data sources:

* `data.aws_ami.ubuntu_20_04`
* `data.aws_vpc.default`

---

## 🏷️ Resource Tags

The EC2 instance uses the following tags:

| Tag         | Value                    |
| ----------- | ------------------------ |
| Name        | `terraform-nginx-server` |
| Environment | `skill-test`             |
| ManagedBy   | `Terraform`              |

The Security Group uses:

| Tag         | Value                |
| ----------- | -------------------- |
| Name        | `terraform-nginx-sg` |
| Environment | `skill-test`         |
| ManagedBy   | `Terraform`          |

Tags make it easier to identify resources and understand their purpose.

---

## 🧹 Infrastructure Teardown

After testing is complete, destroy the Terraform-managed infrastructure:

```
terraform destroy
```

Terraform will display the resources that will be removed.

Confirm with:

```
yes
```

Expected result:

```
Destroy complete! Resources: 2 destroyed.
```

The following resources are destroyed:

* `aws_instance.nginx`
* `aws_security_group.nginx`

The following existing resources are not destroyed:

* Default VPC
* Default subnet
* Internet Gateway

---

## 💰 AWS Cost Cleanup

If the infrastructure is no longer required, run:

```
terraform destroy
```

This removes the EC2 instance and Security Group created by this Terraform project.

This helps prevent unnecessary AWS charges.

---

## 📸 Submission Screenshots

The following screenshots are recommended for the skill-test submission.

### 1. Terraform Init

Show:

```
terraform init
```

with successful initialization.

### 2. Terraform Validate

Show:

```
terraform validate
```

with:

```
Success! The configuration is valid.
```

### 3. Terraform Plan

Show:

```
terraform plan
```

with:

```
Plan: 2 to add, 0 to change, 0 to destroy.
```

### 4. Terraform Apply

Show:

```
terraform apply
```

with:

```
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

Also capture:

```
instance_public_ip = "<PUBLIC_IP>"
```

### 5. Nginx Web Page

Open:

```
http://<PUBLIC_IP>
```

Capture a screenshot showing:

> Welcome to the Terraform-managed Nginx Server

> on Ubuntu

### 6. Terraform Destroy

Show:

```
terraform destroy
```
<img width="1919" height="243" alt="image" src="https://github.com/user-attachments/assets/ecbf8eb9-0449-4a84-b280-b7e58c5aaf46" />


with:

```
Destroy complete! Resources: 2 destroyed.
```

---


## ✅ Assignment Requirements Checklist

| Requirement                       | Status |
| --------------------------------- | ------ |
| AWS provider configured           | ✅      |
| AWS region configured             | ✅      |
| Existing default VPC used         | ✅      |
| Ubuntu 20.04 LTS                  | ✅      |
| `t2.micro` EC2 instance           | ✅      |
| HTTP port 80                      | ✅      |
| SSH port 22                       | ✅      |
| Nginx installed using `user_data` | ✅      |
| Default Nginx page replaced       | ✅      |
| Required custom HTML content      | ✅      |
| Public IP output                  | ✅      |
| Resource tags included            | ✅      |
| No separate VPC created           | ✅      |
| No separate subnet created        | ✅      |
| No Internet Gateway created       | ✅      |
| `terraform destroy` supported     | ✅      |
| README documentation              | ✅      |
| GitHub repository                 | ✅      |
| Nginx deployment verified         | ✅      |

---

## 🧪 Deployment Verification

The deployed Nginx server can be verified using:

```
curl -I http://<PUBLIC_IP>
```

Expected:

```
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)
Content-Type: text/html
```

Terraform state can be verified using:

```
terraform state list
```

Expected resources:

```
data.aws_ami.ubuntu_20_04
data.aws_vpc.default
aws_instance.nginx
aws_security_group.nginx
```

---

## 🔄 Terraform Workflow

The complete workflow is:

```
terraform init
      │
      ▼
terraform fmt
      │
      ▼
terraform validate
      │
      ▼
terraform plan
      │
      ▼
terraform apply
      │
      ▼
Verify Nginx
      │
      ▼
terraform destroy
```

---

##  Security Considerations

This project is designed for a skill-test environment.

For production deployments, the following improvements should be considered:

* Restrict SSH access to trusted IP addresses
* Avoid exposing SSH to `0.0.0.0/0`
* Use AWS Systems Manager Session Manager where appropriate
* Use IAM roles instead of long-lived AWS access keys
* Store secrets in AWS Secrets Manager or Parameter Store
* Enable HTTPS using TLS certificates
* Use a domain name
* Add monitoring and logging
* Apply least-privilege IAM policies
* Use an appropriate production EC2 instance type
* Consider using an Application Load Balancer for production web workloads

---

##  Git and Terraform Files

The repository should not contain:

* `.terraform/`
* `terraform.tfstate`
* `terraform.tfstate.backup`
* `*.tfvars`
* `*.tfvars.json`

These files are excluded through `.gitignore`.

The following file should remain committed:

* `.terraform.lock.hcl`

This locks the Terraform provider version and helps provide consistent Terraform behavior across environments.

---

##  .gitignore

The project uses the following `.gitignore`:

```
.terraform/
*.tfstate
*.tfstate.*
crash.log
crash.*.log
*.tfvars
*.tfvars.json
override.tf
override.tf.json
*_override.tf
*_override.tf.json
.terraformrc
terraform.rc
```

---

##  GitHub Repository

[View the Terraform Nginx Ubuntu repository](https://github.com/Mithunvm92/terraform-nginx-ubuntu)

---

##  Technologies

| Technology         | Purpose                       |
| ------------------ | ----------------------------- |
| Terraform          | Infrastructure as Code        |
| AWS EC2            | Compute instance              |
| AWS VPC            | Network environment           |
| AWS Security Group | Network access control        |
| Ubuntu 20.04 LTS   | Operating system              |
| Nginx              | Web server                    |
| AWS CLI            | AWS management                |
| Git                | Version control               |
| GitHub             | Source-code repository        |
| WSL                | Linux development environment |

---

##  Author

**Mithun Valappil Mani**

AWS & Terraform Skill-Test Project

---

##  Project Status

| Component         | Status                |
| ----------------- | --------------------- |
| Infrastructure    | ✅ Deployed and tested |
| Terraform         | ✅ Validated           |
| EC2               | ✅ Deployed            |
| Nginx             | ✅ Running             |
| HTTP              | ✅ 200 OK              |
| Custom HTML       | ✅ Verified            |
| Terraform Output  | ✅ Public IP available |
| GitHub Repository | ✅ Published           |
| Documentation     | ✅ Completed           |

---

##  License

This project was created as part of an AWS/Terraform skill-test assignment.
