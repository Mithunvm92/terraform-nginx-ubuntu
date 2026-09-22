Terraform-Managed Nginx Server on Ubuntu

Overview

This project provisions an Ubuntu 20.04 LTS EC2 instance running Nginx using Terraform.

The infrastructure is deployed in the existing AWS default VPC and uses Terraform as Infrastructure as Code (IaC).

Architecture

AWS
│
└── Existing Default VPC
    │
    ├── Existing Default Subnet
    │
    └── Terraform-managed Security Group
        ├── HTTP :80
        └── SSH  :22
             │
             ▼
        EC2 Instance
        Ubuntu 20.04 LTS
        t2.micro
             │
             └── user_data
                 ├── Install Nginx
                 └── Configure custom HTML page

Resources Created

Terraform creates the following resources:

EC2 Instance

Ubuntu 20.04 LTS

Instance type: t2.micro

Nginx installed using user_data

Custom HTML page configured

Security Group

TCP port 80 for HTTP

TCP port 22 for SSH

Outbound traffic allowed

Existing AWS Resources Used

The following existing resources are used and are not created by Terraform:

Default VPC

Default subnet

Internet Gateway associated with the default VPC

Project Structure

terraform-nginx-ubuntu/
├── main.tf
├── variables.tf
├── outputs.tf
├── README.md
└── .terraform.lock.hcl

Prerequisites

The following tools are required:

AWS account

IAM user with permissions to manage EC2 and security groups

AWS CLI

Terraform CLI

Verify Terraform:

terraform version

Verify AWS CLI:

aws --version

Verify AWS authentication:

aws sts get-caller-identity

AWS Configuration

Configure the AWS CLI:

aws configure

Example region:

ap-south-1

Do not commit AWS access keys or secret keys to this repository.

Terraform Configuration

1. Initialize Terraform

terraform init

2. Format the Terraform files

terraform fmt

3. Validate the configuration

terraform validate

Expected result:

Success! The configuration is valid.

4. Review the execution plan

terraform plan

The expected plan creates:

2 to add, 0 to change, 0 to destroy

The two resources are:

aws_security_group.nginx

aws_instance.nginx

5. Deploy the infrastructure

terraform apply

When prompted:

Do you want to perform these actions?

Enter:

yes

Nginx Configuration

The EC2 user_data script automatically:

Updates Ubuntu packages.

Installs Nginx.

Replaces the default Nginx index page.

Enables Nginx at boot.

Restarts Nginx.

The custom page displays:

Welcome to the Terraform-managed Nginx Server
on Ubuntu

Access the Web Server

After terraform apply, Terraform outputs the public IP:

instance_public_ip = "<PUBLIC_IP>"

Open the following in a web browser:

http://<PUBLIC_IP>

Example:

http://15.206.209.201

You can also test from the command line:

curl http://<PUBLIC_IP>

Or check the HTTP response:

curl -I http://<PUBLIC_IP>

Expected response:

HTTP/1.1 200 OK

Terraform Outputs

To display the public IP again:

terraform output

Or:

terraform output instance_public_ip

Verify Terraform Resources

List resources managed by Terraform:

terraform state list

Expected resources:

aws_instance.nginx
aws_security_group.nginx

Destroy the Infrastructure

When testing is complete, remove the resources created by Terraform:

terraform destroy

Review the proposed changes and enter:

yes

Terraform should remove:

EC2 instance

Security group

The existing default VPC, subnet, and Internet Gateway are not managed or deleted by this Terraform configuration.

Screenshots

Include screenshots in the submission showing:

Successful terraform init

Successful terraform validate

terraform plan

Successful terraform apply

Nginx web page displaying:

Welcome to the Terraform-managed Nginx Server

on Ubuntu

Successful terraform destroy

Deployment Result

Current test deployment:

AWS Region:       ap-south-1
Instance Type:    t2.micro
OS:               Ubuntu 20.04 LTS
Web Server:       Nginx
Public IP:        15.206.209.201
HTTP Port:        80
SSH Port:         22

Note: The public IP above is specific to the current deployment and may change after the EC2 instance is recreated.

Cleanup

Always run the following after testing to avoid unnecessary AWS charges:

terraform destroy

License

This project was created as part of a Terraform/AWS skill test assignment.
