# IAM User Creation Using Terraform

## Overview
This document provides details on how to create an **AWS IAM User** using **Terraform**, along with key concepts, best practices, and differences between IAM users and roles.

## What is AWS IAM?
AWS **Identity and Access Management (IAM)** allows you to manage access to AWS services and resources securely. It includes:
- **IAM Users**: Individual AWS accounts with specific permissions.
- **IAM Roles**: Assignable identities with permissions that users or AWS services can assume.
- **IAM Policies**: Define permissions for users, groups, or roles.

## Terraform Configuration for IAM User
Below is an example Terraform script to create an **IAM user**, generate an **access key**, and attach an **AWS managed policy**:

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "example_user" {
  name = "terraform-user"
  force_destroy = true
}

resource "aws_iam_access_key" "example_key" {
  user = aws_iam_user.example_user.name
}

resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.example_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

output "access_key_id" {
  value = aws_iam_access_key.example_key.id
}

output "secret_access_key" {
  value     = aws_iam_access_key.example_key.secret
  sensitive = true
}
```

<img width="1137" alt="Screenshot 2025-03-10 at 3 31 59 PM" src="https://github.com/user-attachments/assets/ef04fbb9-75b7-4aa0-bb0e-1ad7536f6581" />


## Key Components of IAM User Management
1. **IAM User**: Represents a person or service interacting with AWS.
2. **IAM Policies**: Define what actions an entity can perform.
3. **IAM Groups**: Grouping of users to manage permissions easily.
4. **Access Keys**: Used for programmatic access to AWS services.
5. **IAM Roles**: Used for granting temporary permissions to users or services.

## Differences Between IAM Users and IAM Roles
| Feature | IAM User | IAM Role |
|---------|---------|---------|
| Assigned To | Individual users | AWS services, users, applications |
| Permissions | Attached via policies | Temporary permissions granted |
| Access Type | Console & programmatic | Only programmatic (assumed) |
| Security | Requires access keys | Uses temporary security credentials |

## Best Practices
- Follow **least privilege principle** – grant only necessary permissions.
- Use **IAM roles** instead of access keys for AWS services.
- Rotate **access keys** regularly and avoid hardcoding them.
- Enable **MFA (Multi-Factor Authentication)** for IAM users.
- Use **IAM groups** for easier permission management.

## Conclusion
IAM is essential for managing AWS security and access control. Terraform simplifies IAM user creation and permission management, making it easy to automate user access.

