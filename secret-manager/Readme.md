# Create AWS Secrets Manager with Terraform

This project demonstrates how to use Terraform to create an AWS Secrets Manager instance to securely store sensitive credentials, such as database usernames and passwords. It includes a KMS key for encryption and enables automatic key rotation for enhanced security. This setup eliminates the need to hardcode sensitive information in your application code, providing a centralized and secure management solution.

## Table of Contents

- [Overview](#overview)
- [What is AWS Secrets Manager?](#what-is-aws-secrets-manager)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [File Structure](#file-structure)
- [Setup Instructions](#setup-instructions)
- [Verification](#verification)
- [Cleanup](#cleanup)
- [Troubleshooting](#troubleshooting)
- [Conclusion](#conclusion)

## Overview

This Terraform configuration creates:

- An AWS Secrets Manager secret to store sensitive credentials (e.g., database username and password).
- An AWS KMS key for encrypting the secret, with automatic rotation enabled.
- A secret version containing the credentials in JSON format.

The setup ensures your sensitive data is securely stored, encrypted, and manageable, with Terraform automating the deployment process.

## What is AWS Secrets Manager?

AWS Secrets Manager is a fully managed service that securely stores and manages sensitive information, such as database credentials, API keys, and other secrets. Key features include:

- **Secure Storage**: Centralized storage to avoid hardcoding secrets in code or config files.
- **Automatic Rotation**: Regularly updates credentials to reduce risks from static secrets.
- **Integration**: Works seamlessly with AWS services like RDS, Redshift, and more.
- **Access Control**: Fine-grained permissions via AWS IAM.
- **Auditing**: Tracks access with logs for compliance and security.
- **Versioning**: Maintains a history of secret changes.

This project uses Secrets Manager to store a database username and password, encrypted with a KMS key.

## Architecture

- **Secrets Manager Secret**: A vault (`demo-credentials`) storing a JSON-encoded username and password.
- **KMS Key**: A custom key for encrypting the secret, with automatic rotation enabled.
- **Terraform**: Orchestrates the creation of these resources in AWS.

## Prerequisites

- **AWS Account**: Configured with IAM credentials (access key and secret key).
- **AWS CLI**: Installed and configured (`aws configure`).
- **Terraform**: Installed (version 0.12+ recommended; tested with AWS provider ~5.0).
- **Text Editor**: e.g., Visual Studio Code (optional for editing files).

## File Structure

```
terraform-demo-secrets/
├── awsecr.tf       # Terraform configuration for Secrets Manager and KMS
└── README.md       # This documentation
```

## Setup Instructions

1. **Create Project Directory**:

   - Create a folder named `terraform-demo-secrets`:
     ```bash
     mkdir terraform-demo-secrets
     cd terraform-demo-secrets
     ```

2. **Configure AWS Credentials**:

   - Set up your AWS CLI:
     ```bash
     aws configure
     ```
     - Enter your `aws_access_key_id`, `aws_secret_access_key`, and `region` (e.g., `ap-south-1`).
   - Alternatively, set environment variables:
     ```bash
     export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY"
     export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_KEY"
     export AWS_DEFAULT_REGION="ap-south-1"
     ```

3. **Create `awsecr.tf`**:

   - Add the following Terraform configuration to `awsecr.tf`:

     ```hcl
     provider "aws" {
       region = "ap-south-1"  # Replace with your preferred region
     }

     resource "aws_kms_key" "demo_kms_key" {
       description             = "KMS key for demo credentials rotation"
       enable_key_rotation     = true
       deletion_window_in_days = 7
     }

     resource "aws_secretsmanager_secret" "demo_credentials" {
       name        = "demo-credentials"
       kms_key_id  = aws_kms_key.demo_kms_key.key_id
     }

     resource "aws_secretsmanager_secret_version" "demo_credentials_version" {
       secret_id     = aws_secretsmanager_secret.demo_credentials.id
       secret_string = jsonencode({
         username = "db_admin"
         password = "P@ssw0rd"
       })
     }
     ```

4. **Initialize Terraform**:

   ```bash
   terraform init
   ```

   - This downloads the AWS provider plugin.

5. **Review the Plan**:

   ```bash
   terraform plan
   ```

   - Verify the resources Terraform will create (KMS key, Secrets Manager secret, and secret version).

6. **Deploy the Infrastructure**:
   ```bash
   terraform apply
   ```
   - Type `yes` to confirm. Deployment takes a few minutes.

## Verification

1. **AWS Console**:

   - **Secrets Manager**: Go to AWS Secrets Manager > Secrets. Look for `demo-credentials`.
   - **KMS**: Go to AWS KMS > Keys. Verify the `demo_kms_key` exists with rotation enabled.

2. **CLI (Optional)**:
   - Retrieve the secret:
     ```bash
     aws secretsmanager get-secret-value --secret-id demo-credentials --region ap-south-1
     ```
     - Output will include the JSON: `{"username": "db_admin", "password": "P@ssw0rd"}`.

## Cleanup

To destroy the resources and avoid charges:

```bash
terraform destroy
```

- Type `yes` to confirm.

## Troubleshooting

- **Permission Denied**:
  - Ensure your IAM user/role has permissions for `secretsmanager:*` and `kms:*`.
  - Example IAM policy:
    ```json
    {
      "Effect": "Allow",
      "Action": ["secretsmanager:*", "kms:*"],
      "Resource": "*"
    }
    ```
- **Region Issues**:
  - Verify the region in `provider "aws"` matches your AWS CLI configuration.
- **Secret Not Found**:

  - Check Terraform logs for errors during `apply`. Ensure `terraform apply` completed successfully.

  ![alt text](<Screenshot 2025-03-12 at 10.35.41 PM.png>)

## Conclusion

This Terraform setup creates a secure AWS Secrets Manager instance with an encrypted secret and automatic key rotation via KMS. It’s an ideal solution for managing sensitive credentials, avoiding hardcoding, and enhancing application security. Extend this by integrating the secret with an RDS instance or other AWS services as needed.

---

### Notes

- **Region**: Uses `ap-south-1`. Update `awsecr.tf` if you prefer a different region.
- **Security**: The example uses a hardcoded password (`P@ssw0rd`) for simplicity. In production, use dynamic secrets or Terraform variables:
  ```hcl
  variable "db_password" {
    type      = string
    sensitive = true
  }
  secret_string = jsonencode({
    username = "db_admin"
    password = var.db_password
  })
  ```
- **Date**: Updated for March 12, 2025 context; assumes AWS services remain consistent.
