# PostgreSQL AWS RDS using Terraform

## Overview
This repository contains Terraform scripts to provision an **Amazon RDS PostgreSQL** instance on AWS. The setup includes:
- An RDS instance
- A security group allowing inbound PostgreSQL connections
- A DB subnet group for high availability

## Prerequisites
Ensure you have the following installed:
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- AWS CLI ([Install & Configure](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html))
- AWS credentials configured via `aws configure`

## Deployment Steps
1. **Clone the Repository:**
   ```sh
   git clone https://github.com/yourusername/postgresql-rds-terraform.git
   cd postgresql-rds-terraform
   ```
2. **Initialize Terraform:**
   ```sh
   terraform init
   ```
3. **Review and Update Variables:**
   - Modify `variables.tf` or set environment variables for **db_username** and **db_password**
4. **Apply the Configuration:**
   ```sh
   terraform apply -auto-approve
   ```
5. **Retrieve RDS Endpoint:**
   ```sh
   terraform output rds_endpoint
   ```

## Connecting to RDS via PgAdmin
1. Open **PgAdmin** and create a new connection.
2. Use the **RDS endpoint** from the Terraform output.
3. Enter the **username** and **password** set in `variables.tf`.
4. Click **Save & Connect**.

## Destroy the Infrastructure
To delete all resources:
```sh
terraform destroy -auto-approve
```

## Security Best Practices
- Avoid using `0.0.0.0/0` in security groups for production.
- Store sensitive credentials in AWS Secrets Manager or Terraform variables.

## References
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Amazon RDS Documentation](https://docs.aws.amazon.com/rds/index.html)

---

### Author
Maintained by Navneet Shahi(https://github.com/navneet072300).

