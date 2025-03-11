# Setting Up Redis Cluster in AWS Using Terraform

## Introduction

This guide provides a step-by-step process to set up a Redis Cluster in AWS using Terraform. We will use AWS ElastiCache for Redis, which is a fully managed Redis service, ensuring high availability and scalability.

## Prerequisites

Before proceeding, ensure you have the following:

- An AWS account
- Terraform installed on your machine
- AWS CLI configured with necessary permissions

## Step 1: Initialize the Terraform Project

Create a new directory for your Terraform configuration and initialize it:

```sh
mkdir terraform-redis-cluster && cd terraform-redis-cluster
terraform init
```

## Step 2: Define AWS Provider

Create a file named `provider.tf` and define the AWS provider:

```hcl
provider "aws" {
  region = "us-east-1" # Change to your desired region
}
```

## Step 3: Create a VPC and Subnets

Create a file named `vpc.tf` to define the VPC and subnets:

```hcl
resource "aws_vpc" "redis_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "redis_subnet" {
  count = 2
  vpc_id = aws_vpc.redis_vpc.id
  cidr_block = element(["10.0.1.0/24", "10.0.2.0/24"], count.index)
  availability_zone = element(["us-east-1a", "us-east-1b"], count.index)
}
```

## Step 4: Create a Security Group

Create a file named `security_group.tf` and define a security group:

```hcl
resource "aws_security_group" "redis_sg" {
  vpc_id = aws_vpc.redis_vpc.id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict access as needed
  }
}
```

## Step 5: Create Redis Cluster

Create a file named `redis.tf` to define the Redis cluster:

```hcl
resource "aws_elasticache_replication_group" "redis_cluster" {
  replication_group_id          = "redis-cluster"
  replication_group_description = "Redis Cluster with Multi-AZ"
  node_type                     = "cache.t3.micro"
  number_cache_clusters         = 2
  parameter_group_name          = "default.redis7"
  engine_version                = "7.0"
  automatic_failover_enabled    = true
  subnet_group_name             = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids            = [aws_security_group.redis_sg.id]
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = aws_subnet.redis_subnet[*].id
}
```

## Step 6: Apply Terraform Configuration

Run the following commands to apply the Terraform configuration:

```sh
terraform init
terraform plan
terraform apply -auto-approve
```

## Step 7: Connect to Redis Cluster

Once the cluster is created, retrieve the endpoint from AWS Console or by running:

```sh
aws elasticache describe-replication-groups --query 'ReplicationGroups[0].NodeGroups[0].PrimaryEndpoint.Endpoint'
```

Connect to Redis using a client:

```sh
redis-cli -h <primary-endpoint> -p 6379
```

![alt text](<Screenshot 2025-03-11 at 12.25.45 PM.png>)

## Cleanup

To destroy the infrastructure when no longer needed:

```sh
terraform destroy -auto-approve
```

## Conclusion

This guide provided a step-by-step approach to setting up a Redis Cluster in AWS using Terraform. You now have a scalable, highly available Redis setup ready for production use.
