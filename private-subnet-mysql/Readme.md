# Terraform: Access Private Subnet MySQL RDS over SSH

This project demonstrates how to use Terraform to deploy an AWS infrastructure with a custom VPC, including an EC2 instance in a public subnet and a MySQL RDS database in a private subnet. The setup ensures the RDS instance is inaccessible from the internet and can only be accessed via SSH through the EC2 instance (acting as a bastion host).

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [File Structure](#file-structure)
- [Setup Instructions](#setup-instructions)
- [Accessing the RDS Instance](#accessing-the-rds-instance)
- [Outputs](#outputs)
- [Cleanup](#cleanup)
- [Troubleshooting](#troubleshooting)
- [Conclusion](#conclusion)

## Overview

This Terraform configuration creates:

- A custom VPC with public and private subnets.
- An EC2 instance in the public subnet for public access (e.g., web server).
- A MySQL RDS instance in the private subnet for secure database storage.
- Security groups and route tables to enforce network isolation and connectivity.
- An Elastic IP (EIP) for the EC2 instance.

The EC2 instance serves as a bastion host, allowing SSH access to connect to the private RDS instance.

## Architecture

- **VPC**: A logically isolated network with a CIDR block of `10.0.0.0/16`.
- **Public Subnet**: Hosts the EC2 instance, accessible via the internet through an Internet Gateway.
- **Private Subnets**: Host the MySQL RDS instance, isolated from the internet.
- **Internet Gateway**: Enables internet access for the public subnet.
- **Route Tables**: Separate routing for public (with internet access) and private (no direct internet) subnets.
- **Security Groups**:
  - EC2: Allows HTTP (port 80) and SSH (port 22) from anywhere.
  - RDS: Allows MySQL (port 3306) only from the EC2 security group.
- **Elastic IP**: Assigned to the EC2 instance for a static public IP.

![alt text](<Screenshot 2025-03-12 at 7.39.40 PM.png>)

## Prerequisites

- **AWS Account**: Configured with IAM credentials (access key and secret key).
- **AWS CLI**: Installed and configured (`aws configure`).
- **Terraform**: Installed (version 0.12+ recommended; tested with ~5.0 provider).
- **SSH Client**: e.g., MobaXterm, OpenSSH, or macOS Terminal.
- **Key Pair**: An AWS EC2 key pair (e.g., `three-tier.pem`) for SSH access.

## File Structure

```
.
├── provider.tf           # AWS provider configuration
├── vpc.tf               # VPC creation
├── subnets.tf           # Public and private subnets
├── security_groups.tf   # Security groups for EC2 and RDS
├── ec2_instance.tf      # EC2 instance deployment
├── db_instance.tf       # RDS MySQL instance
├── route_table.tf       # Route tables for public and private subnets
├── internet_gateway.tf  # Internet Gateway setup
├── elastic_ip.tf        # Elastic IP for EC2
├── variables.tf         # Input variables
└── outputs.tf           # Output values (e.g., IP, endpoint)
```

## Setup Instructions

1. **Clone or Create the Repository**:

   - Copy the Terraform files into a directory or clone this repository.

2. **Configure AWS Credentials**:

   - Ensure your AWS CLI is configured:
     ```bash
     aws configure
     ```
   - Or set credentials in `provider.tf` (not recommended for security):
     ```hcl
     provider "aws" {
       region     = "ap-south-1"
       access_key = "YOUR_ACCESS_KEY"
       secret_key = "YOUR_SECRET_KEY"
     }
     ```

3. **Initialize Terraform**:

   ```bash
   terraform init
   ```

   - This downloads the AWS provider plugin.

4. **Review the Plan**:

   ```bash
   terraform plan
   ```

   - Check the resources Terraform will create.

5. **Deploy the Infrastructure**:

   ```bash
   terraform apply
   ```

   - Type `yes` to confirm. Wait ~10-15 minutes for provisioning.

6. **Note the Outputs**:
   - After deployment, Terraform will display outputs like `web_public_ip`, `database_endpoint`, etc.

## Accessing the RDS Instance

Since the RDS instance is in a private subnet, you’ll access it via the EC2 instance (bastion host) over SSH.

1. **Get Outputs**:

   ```bash
   terraform output
   ```

   - Note `web_public_ip` (e.g., `54.123.456.789`) and `database_endpoint` (e.g., `tutorial-database.abcd1234.ap-south-1.rds.amazonaws.com`).

2. **SSH into the EC2 Instance**:

   - Use your key pair (e.g., `three-tier.pem`):
     ```bash
     ssh -i three-tier.pem ec2-user@<web_public_ip>
     ```
   - Replace `<web_public_ip>` with the value from `web_public_ip`.

3. **Install MySQL Client on EC2**:

   - Update packages and install the MySQL client:
     ```bash
     sudo apt-get update -y && sudo apt install mysql-client -y
     ```

4. **Connect to RDS**:

   - Use the `database_endpoint` and `database_port` from outputs:
     ```bash
     mysql -h <database_endpoint> -P 3306 -u admin -p
     ```
   - Enter the password: `admin12345678`.
   - Example:
     ```bash
     mysql -h tutorial-database.abcd1234.ap-south-1.rds.amazonaws.com -P 3306 -u admin -p
     ```

5. **Verify Database**:
   - In the MySQL shell, check if the `tutorial` database exists:
     ```sql
     SHOW DATABASES;
     ```

## Outputs

After `terraform apply`, the following outputs are available:

- `web_public_ip`: Public IP of the EC2 instance.
- `web_public_dns`: Public DNS name of the EC2 instance.
- `database_endpoint`: RDS MySQL endpoint (hostname).
- `database_port`: RDS MySQL port (default: 3306).

Retrieve them anytime with:

```bash
terraform output <output_name>
```

## Cleanup

To destroy all resources and avoid charges:

```bash
terraform destroy
```

- Type `yes` to confirm.

## Troubleshooting

- **RDS Connection Fails**:
  - Ensure the EC2 security group allows outbound traffic to port 3306.
  - Verify the RDS security group allows inbound 3306 from the EC2 security group.
  - Check the RDS instance is running (`terraform apply` completed successfully).
- **SSH Fails**:
  - Confirm the key pair (`three-tier`) matches your `.pem` file.
  - Check the EC2 security group allows SSH (port 22) from your IP.
- **MySQL Version Error**:
  - If MySQL 5.7 isn’t supported (e.g., deprecated by March 2025), update `db_instance.tf` to use `engine_version = "8.0"` and `parameter_group_name = "default.mysql8.0"`.

## Conclusion

This Terraform setup provides a secure, scalable AWS infrastructure with a public EC2 instance and a private MySQL RDS instance. By leveraging SSH tunneling through the EC2 bastion host, you maintain strict access control to the RDS database while adhering to cloud best practices.

![alt text](<Screenshot 2025-03-12 at 8.16.53 PM.png>)
![alt text](<Screenshot 2025-03-12 at 8.18.03 PM.png>)
![alt text](<Screenshot 2025-03-12 at 8.18.21 PM.png>)
![alt text](<Screenshot 2025-03-12 at 8.19.51 PM.png>)
![alt text](<Screenshot 2025-03-12 at 8.19.07 PM.png>)
![alt text](<Screenshot 2025-03-12 at 8.20.19 PM.png>)

---

### Notes

- **Region**: The example uses `ap-south-1`. Change it in `provider.tf` if needed.
- **Security**: Hardcoded credentials (`admin12345678`) are used for simplicity. In production, use AWS Secrets Manager or variables with `sensitive = true`.
- **Updates**: As of March 12, 2025, MySQL 5.7 may be deprecated. Adjust to MySQL 8.0 if you encounter compatibility issues (see earlier responses).
