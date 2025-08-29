# AWS Terraform Projects

This repository contains a collection of **Terraform** projects for managing and building infrastructure on the **Amazon Web Services (AWS)** cloud. The goal is to provide practical, organized examples of Terraform configurations for various scenarios.

## Repository Structure

Each folder in this repository represents a separate Terraform project.
- `aws-terraform-initialize/`
- `...`

### Current Project: `terraform-demo-project`

This project demonstrates how to build a Virtual Private Cloud (VPC) with public and private subnets, along with creating resources such as EC2 servers and S3 buckets.

#### Key Features:
- **Terraform Settings:** Defines the required Terraform version and uses a local backend.
- **Provider:** Utilizes the AWS provider.
- **Variables:** Defines variables for the region, server count, and bucket names to allow for easy customization.
- **Locals:** Sets reusable local values.
- **Networking:** Creates a VPC, Internet Gateway, Route Table, and public/private subnets.
- **Data Sources:** Fetches the latest Ubuntu AMI.
- **Resources:**
    - Creates **EC2** servers using the `count` meta-argument.
    - Creates **S3** buckets using the `for_each` meta-argument.
- **Outputs:** Displays key information after deployment, such as public IPs and resource IDs.

#### How to Use:
1.  Install Terraform and the AWS CLI on your machine.
2.  Set up your AWS credentials.
3.  Navigate to the project directory: `cd terraform-branch-project`.
4.  Initialize the project: `terraform init`.
5.  View the execution plan: `terraform plan`.
6.  Apply the configuration: `terraform apply`.
