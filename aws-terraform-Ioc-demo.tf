# 1. Terraform Settings
terraform {
  required_version = ">= 1.5.0"
  backend "local" {
    path = "terraform.tfstate"
  }
}


# 2. Provider
provider "aws" {
  region = var.region
}


# 3. Variables
variable "region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "server_count" {
  description = "Number of EC2 servers"
  default     = 2
}

variable "bucket_names" {
  description = "List of S3 bucket names"
  type        = list(string)
  default     = ["logs", "media", "backup"]
}


# 4. Locals
locals {
  instance_type = "t2.micro"
  project_name  = "terraform-demo"
}

# 4.5 Networking
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${local.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.project_name}-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${local.project_name}-public-rt"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "${local.project_name}-public-subnet"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "${local.project_name}-private-subnet"
  }
}


# 5. Data Source (Use existing Ubuntu AMI)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}


# 6. Resource: EC2 Instances (with count + provisioner)
resource "aws_instance" "servers" {
  count         = var.server_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.instance_type
  subnet_id     = aws_subnet.public.id
  # Using the default security group of the VPC.
  # NOTE: By default, this SG denies all inbound traffic. You'll need to add rules to allow access (e.g., for SSH).
  vpc_security_group_ids = [aws_vpc.main.default_security_group_id]

  tags = {
    Name = "${local.project_name}-server-${count.index}"
  }
}


# 7. Resource: S3 Buckets (for_each)
resource "aws_s3_bucket" "buckets" {
  for_each = toset(var.bucket_names)
  bucket   = "${local.project_name}-${each.key}"
}


# 9. Depends_on Example (App Server depends on Buckets)
resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.instance_type
  subnet_id     = aws_subnet.private.id
  # This instance is in a private subnet and will not have a public IP.
  # It also uses the default security group.
  vpc_security_group_ids = [aws_vpc.main.default_security_group_id]

  tags = {
    Name = "${local.project_name}-app"
  }
}


# 10. Outputs
output "ec2_public_ips" {
  description = "Public IPs of EC2 servers"
  value       = aws_instance.servers[*].public_ip
}

output "bucket_names" {
  description = "Created S3 buckets"
  value       = [for b in aws_s3_bucket.buckets : b.bucket]
}

output "app_server_ip" {
  description = "Private IP of the app server"
  value       = aws_instance.app_server.private_ip
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.id
}