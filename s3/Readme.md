# Terraform S3 Bucket Creation and Import

This project uses Terraform to create a new AWS S3 bucket and import an existing one in the `ap-south-1` region.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Setup Instructions](#setup-instructions)
- [Troubleshooting](#troubleshooting)
- [Verification](#verification)
- [Cleanup](#cleanup)

## Overview

- Creates a new S3 bucket (`terraform-new-s3buc` or a unique variant).
- Imports an existing S3 bucket (`terraform-s3buc`).

## Prerequisites

- AWS account with credentials (access key: `AKIAWOAVSMTW5NSLVQVV`).
- Terraform installed.
- Existing bucket `terraform-s3buc` in `ap-south-1` (create manually if needed).

## Project Structure

```
terraform-s3-project/
├── main.tf            # Main configuration
├── variables.tf       # Variable definitions
├── terraform.tfvars   # Credentials and bucket names
└── README.md          # This file
```

## Setup Instructions

1. **Prepare Files**:

   - Use the provided `main.tf`, `variables.tf`, and `terraform.tfvars`.
   - Ensure `terraform.tfvars` is not committed to version control.

2. **Initialize**:

   ```bash
   terraform init
   ```

3. **Handle Existing Buckets**:

   - If `terraform-new-s3buc` exists:
     ```bash
     terraform import aws_s3_bucket.new_bucket terraform-new-s3buc
     ```
   - Or update `new_bucket_name` to a unique value (e.g., `terraform-new-s3buc-20250315`) in `terraform.tfvars`.

4. **Import Existing Bucket**:

   ```bash
   terraform import aws_s3_bucket.imported_bucket terraform-s3buc
   ```

5. **Apply**:

   ```bash
   terraform apply -auto-approve
   ```

   ![alt text](<Screenshot 2025-03-15 at 2.55.55 PM.png>)

## Troubleshooting

- **Error: BucketAlreadyOwnedByYou (409)**:
  - Fix: Import the bucket or use a unique name.
  - Example:
    ```bash
    terraform import aws_s3_bucket.new_bucket terraform-new-s3buc
    ```

## Verification

- Run:
  ```bash
  terraform plan
  ```
- Check S3 in AWS Console (`ap-south-1`).

## Cleanup

- Destroy:
  ```bash
  terraform destroy -auto-approve
  ```

```

### Key Points
- **Region**: Set to `ap-south-1` as specified.
- **Bucket Names**: `terraform-new-s3buc` may need a unique suffix (e.g., `terraform-new-s3buc-20250315`) if it already exists.
- **Credentials**: Your provided keys are used; ensure they have S3 permissions.

Try these steps, and let me know if you hit any issues!
```
