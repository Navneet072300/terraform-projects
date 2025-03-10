# AWS ElastiCache - Memcached Cluster using Terraform

## Introduction
Amazon ElastiCache is a managed caching service that supports both **Memcached** and **Redis**. It helps improve application performance by reducing latency and offloading database workloads. In this guide, we will discuss how to create a **Memcached Cluster** using Terraform, along with key insights into Memcached, ElastiCache, and differences between Redis and Memcached.

## What is Memcached?
Memcached is an open-source, high-performance, distributed memory object caching system used for speeding up dynamic web applications by reducing database load. It stores key-value pairs in memory to provide quick data retrieval.

### Key Features:
- **In-memory caching** for fast data access
- **Distributed architecture** with multi-threaded design
- **No persistence** – data is lost on reboot
- **Simple key-value store**
- **Supports horizontal scaling**

## What is AWS ElastiCache?
AWS ElastiCache is a fully managed caching service that supports Memcached and Redis. It provides a highly scalable and distributed caching layer for cloud applications.

### Benefits of AWS ElastiCache:
- **Fully managed**: No need to manage clusters manually
- **High availability**: Supports multi-AZ deployments for failover
- **Scalability**: Easily scale in/out by adding/removing nodes
- **Secure**: Integrated with AWS IAM and VPC for security

## Differences Between Redis and Memcached
| Feature         | Redis  | Memcached |
|---------------|--------|------------|
| Data Model    | Key-value store with data structures (Lists, Sets, Hashes, etc.) | Simple key-value store |
| Persistence   | Supports AOF and RDB snapshots | No persistence (data is lost on restart) |
| Performance  | Single-threaded but optimized | Multi-threaded for high performance |
| Use Cases    | Session storage, message queues, real-time analytics | Caching frequently accessed data |
| Clustering   | Supports native clustering | Clustering requires client-side sharding |

## Creating a Memcached Cluster using Terraform
Below is a sample Terraform configuration to create a **Memcached Cluster** using AWS ElastiCache:

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_elasticache_cluster" "memcached" {
  cluster_id           = "memcached-cluster"
  engine               = "memcached"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 2
  parameter_group_name = "default.memcached1.6"
  port                 = 11211
  subnet_group_name    = aws_elasticache_subnet_group.memcached_subnet_group.name
}

resource "aws_elasticache_subnet_group" "memcached_subnet_group" {
  name       = "memcached-subnet-group"
  subnet_ids = ["subnet-xxxxxxxx", "subnet-yyyyyyyy"]
}
```

### Steps to Deploy
1. **Initialize Terraform**
   ```sh
   terraform init
   ```
2. **Plan the deployment**
   ```sh
   terraform plan
   ```
3. **Apply the configuration**
   ```sh
   terraform apply -auto-approve
   ```
4. **Retrieve connection details**
   ```sh
   aws elasticache describe-cache-clusters --show-cache-node-info
   ```

## Connecting Memcached to Your Application
To connect to the Memcached cluster, use a client like `telnet` or a programming language-specific client (Python, Node.js, Go, etc.).

Example using `telnet`:
```sh
telnet <cache-node-endpoint> 11211
```

Example using Python:
```python
import memcache
client = memcache.Client(["<cache-node-endpoint>:11211"], debug=True)
client.set("key", "value")
print(client.get("key"))
```
<img width="1134" alt="Screenshot 2025-03-10 at 1 54 20 PM" src="https://github.com/user-attachments/assets/7d4388f8-c03f-4e66-b051-8c4ad6f88d6c" />


## Additional Notes
- Always use **private subnets** for better security.
- Configure **IAM roles and security groups** to control access.
- Use **CloudWatch** to monitor cache performance.
- If you need **persistent storage**, use Redis instead of Memcached.

---

## Conclusion
Using **Terraform** to create and manage an **AWS ElastiCache Memcached cluster** makes infrastructure deployment more efficient and scalable. Memcached is ideal for applications that require fast, ephemeral data caching, while Redis is better suited for scenarios that require persistence and complex data structures.

For more details, refer to:
- [AWS ElastiCache Documentation](https://docs.aws.amazon.com/elasticache/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---
### Author: Navneet Shahi

