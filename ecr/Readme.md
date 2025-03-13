Here's a README file for creating an Amazon Elastic Container Registry (ECR) in AWS using Terraform, based on the provided information and structured for clarity:

---

# Create Amazon ECR Repository with Terraform

This project provides a Terraform configuration to create an Amazon Elastic Container Registry (ECR) repository in AWS. The setup includes basic files to define the infrastructure, variables, and provider configuration.

## Table of Contents

- [What is Amazon Elastic Container Registry (ECR)?](#what-is-amazon-elastic-container-registry-ecr)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Setup Instructions](#setup-instructions)
- [Usage](#usage)
- [Cleanup](#cleanup)
- [Conclusion](#conclusion)

## What is Amazon Elastic Container Registry (ECR)?

Amazon Elastic Container Registry (ECR) is a fully managed Docker container registry service provided by AWS. It allows you to store, manage, and deploy container images securely.

### Key Features

- **Private Container Registry**: Secure storage for Docker images with access control.
- **Integration**: Works seamlessly with Amazon ECS and AWS Fargate.
- **Image Scanning**: Built-in vulnerability scanning for images.
- **Lifecycle Policies**: Automate cleanup of unused images.
- **Access Control**: Fine-grained permissions via AWS IAM.
- **Cross-Region Replication**: Replicate images across AWS regions.

### Basic Concepts

- **Repository**: A storage location for Docker images.
- **Image**: A standalone package containing software and dependencies.
- **Registry URI**: Unique URL for accessing the ECR repository.

## Prerequisites

- AWS account with configured credentials (e.g., via AWS CLI or environment variables).
- Terraform installed (version 0.13 or later recommended).
- Basic knowledge of Terraform and AWS.

## Project Structure

```
.
├── main.tf                # Core Terraform configuration
├── variables.tf          # Variable definitions
├── provider.tf           # AWS provider configuration
├── variables.auto.tfvars # Variable values
└── README.md             # This file
```

## Setup Instructions

Follow these steps to create an ECR repository using Terraform:

### Step 1: Clone or Create the Files

- Clone this repository or manually create the files with the content below.

#### `main.tf`

```hcl
provider "aws" {
  region = var.aws_region
}

resource "aws_ecr_repository" "example_ecr_repo" {
  name = var.ecr_repo_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_repo_url" {
  value = aws_ecr_repository.example_ecr_repo.repository_url
}
```

#### `variables.tf`

```hcl
variable "aws_region" {
  description = "The AWS region where the ECR repository will be created."
  type        = string
}

variable "ecr_repo_name" {
  description = "The name of the ECR repository."
  type        = string
}
```

#### `provider.tf`

```hcl
provider "aws" {
  region = var.aws_region
}
```

#### `variables.auto.tfvars`

```hcl
aws_region    = "us-west-2"      # Change to your preferred region
ecr_repo_name = "demo-ecr-repo"  # Change to your preferred repository name
```

### Step 2: Deploy the ECR Repository

1. **Initialize Terraform**:

   ```bash
   terraform init
   ```

   This downloads the AWS provider plugin.

2. **Apply the Configuration**:
   ```bash
   terraform apply
   ```
   - Review the plan and type `yes` to confirm.
   - After completion, note the `ecr_repo_url` output.

### Step 3: Verify in AWS Console

- Log in to the AWS Management Console.
- Navigate to **ECR > Repositories**.
- Confirm that the repository (`demo-ecr-repo` or your chosen name) exists.

## Usage

- Use the output `ecr_repo_url` to push/pull Docker images:
  ```bash
  docker tag my-image:latest <ecr_repo_url>:latest
  aws ecr get-login-password --region <aws_region> | docker login --username AWS --password-stdin <ecr_repo_url>
  docker push <ecr_repo_url>:latest
  ```

## Cleanup

To remove the ECR repository:

```bash
terraform destroy
```

- Type `yes` to confirm deletion.

![alt text](<Screenshot 2025-03-13 at 8.55.28 PM.png>)
![alt text](<Screenshot 2025-03-13 at 8.55.15 PM.png>)

## Conclusion

This Terraform configuration simplifies creating an ECR repository in AWS. It enables secure storage and management of Docker images with minimal setup. Customize the variables in `variables.auto.tfvars` to suit your needs.

For more details, refer to the [AWS ECR documentation](https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html) or [Terraform AWS Provider documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository).

---

### Notes

- Ensure your AWS credentials are configured (e.g., via `~/.aws/credentials` or environment variables like `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`).
- Adjust the region and repository name in `variables.auto.tfvars` as needed.
- This README is based on the article by Monica Mahire, updated as of December 17, 2023, and tailored for use on March 13, 2025.
