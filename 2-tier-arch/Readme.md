# AWS Two-Tier Architecture using Terraform

## Overview

This document provides the implementation details for deploying a two-tier architecture on AWS using Terraform. The architecture consists of:

- A Virtual Private Cloud (VPC) with two public subnets and two private subnets.
- An Application Load Balancer (ALB) distributing traffic to EC2 instances in the public subnets.
- An RDS MySQL instance deployed in a private subnet.
- Internet Gateway and Elastic IPs for external access.

## Architecture Components

![alt text](<Screenshot 2025-03-11 at 1.54.19 PM.png>)

### **1. Virtual Private Cloud (VPC)**

- CIDR: `10.0.0.0/16`
- Instance Tenancy: `default`

### **2. Subnets**

- Public Subnet 1: `10.0.1.0/24` (Availability Zone: `ap-south-1a`)
- Public Subnet 2: `10.0.2.0/24` (Availability Zone: `ap-south-1b`)
- Private Subnet 1: `10.0.3.0/24` (Availability Zone: `ap-south-1a`)
- Private Subnet 2: `10.0.4.0/24` (Availability Zone: `ap-south-1b`)

### **3. Internet Gateway**

- Enables internet access for instances in public subnets.

### **4. Load Balancer**

- Application Load Balancer (ALB) directing traffic to EC2 instances in public subnets.

### **5. EC2 Instances**

- One EC2 instance in each public subnet for handling incoming requests.

### **6. RDS MySQL Database**

- Deployed in private subnets for security.

## Terraform Implementation

### **1. Provider Configuration (`provider.tf`)**

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region  = "ap-south-1"
  profile = "default"
}
```

### **2. Network Resources (`network_resources.tf`)**

```hcl
resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = { Name = "vpc-project" }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = { Name = "ig-project" }
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = { Name = "public-1" }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = { Name = "public-2" }
}

resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false
  tags = { Name = "private-1" }
}

resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = false
  tags = { Name = "private-2" }
}
```

### **3. Security Groups (`security_resources.tf`)**

```hcl
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

![alt text](<Screenshot 2025-03-11 at 2.22.17 PM.png>)
![alt text](<Screenshot 2025-03-11 at 2.23.38 PM.png>)
![alt text](<Screenshot 2025-03-11 at 2.33.12 PM.png>)
![alt text](<Screenshot 2025-03-11 at 2.34.10 PM.png>)
![alt text](<Screenshot 2025-03-11 at 2.35.12 PM.png>)
![alt text](<Screenshot 2025-03-11 at 2.36.50 PM.png>)

## Conclusion

This Terraform setup creates a scalable and secure two-tier architecture in AWS with a VPC, public/private subnets, an ALB, EC2 instances, and an RDS MySQL database. Further enhancements can include Auto Scaling, IAM roles, and monitoring with CloudWatch.
