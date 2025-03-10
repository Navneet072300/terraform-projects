# VPC Creation Using Terraform

## Overview
This document provides details on how to create an **AWS Virtual Private Cloud (VPC)** using **Terraform**, along with some key concepts and best practices.

## What is a VPC?
A **Virtual Private Cloud (VPC)** is a logically isolated network within AWS where you can launch AWS resources. It provides full control over:
- IP addressing
- Subnets
- Route tables
- Internet gateways
- Security groups and network ACLs

## Terraform Configuration for VPC
Below is an example Terraform script to create a VPC with subnets, an internet gateway, and a route table:

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "MainVPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "MainIGW"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route" "default_route" {
  route_table_id = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
```

<img width="1440" alt="Screenshot 2025-03-10 at 3 31 18 PM" src="https://github.com/user-attachments/assets/2de7a5d9-3b86-419d-b21d-990cf3940216" />


## Key Components of a VPC
1. **CIDR Block**: Defines the range of IP addresses for the VPC.
2. **Subnets**: Logical subdivisions of the VPC, can be public or private.
3. **Internet Gateway (IGW)**: Enables communication between the VPC and the internet.
4. **Route Table**: Determines how network traffic is directed.
5. **Security Groups & Network ACLs**: Control inbound and outbound traffic.

## Differences Between VPC and Traditional Networking
| Feature | AWS VPC | Traditional Networking |
|---------|--------|--------------------|
| Scalability | Highly scalable | Limited by hardware |
| Security | Security groups & ACLs | Hardware firewalls |
| Cost | Pay-as-you-go | High upfront cost |
| Management | Fully managed by AWS | Requires manual configuration |

## Best Practices
- Use **private subnets** for sensitive resources.
- Implement **NAT gateways** for internet access in private subnets.
- Enable **VPC Flow Logs** for monitoring network traffic.
- Use **AWS Security Groups** to restrict access to resources.

## Conclusion
VPCs provide a secure, scalable, and customizable environment for deploying AWS resources. Using Terraform, you can automate the creation and management of VPCs efficiently.



