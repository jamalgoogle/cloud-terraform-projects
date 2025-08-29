# AWS Terraform Projects

This repository contains a collection of **Terraform** projects for managing and building infrastructure on the **Amazon Web Services (AWS)** cloud. The goal is to provide practical, organized examples of Terraform configurations for various scenarios.

## Repository Structure

Each folder in this repository represents a separate Terraform project.
- `aws-terraform-initialize/`
- `...`
# AWS Terraform Projects

This repository is a collection of Terraform configurations for provisioning and managing various cloud infrastructure projects on Amazon Web Services (AWS). Each directory is a separate project with its own set of Terraform files.

## Repository Structure

Each project is located in its own directory, each file in its own specific branch, making them independent and easy to navigate through the branches.


To run a project, simply navigate into its directory.

## How to Use

1.  **Prerequisites:** Ensure you have **Terraform** and the **AWS CLI** installed and configured on your system.
2.  **Navigate:** Go to the directory of the project you want to deploy.
    ```sh
    cd project-name
    ```
3.  **Initialize:** Run `terraform init` to download the required provider plugins.
4.  **Plan:** Use `terraform plan` to see the resources that will be created without making any changes.
5.  **Apply:** Run `terraform apply` to deploy the infrastructure.
