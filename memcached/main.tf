#defining the provider as aws
provider "aws" {
    region     = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}

#create a ElastiCache MemCached Cluster
resource "aws_elasticache_cluster" "demo_cluster" {
  cluster_id           = "demo-cluster"
  engine               = "memcached"
  node_type            = "cache.t4g.micro"
  num_cache_nodes      = 2
  port                 = 11211
  tags = {
    Name = "mynewcluster"
  }
}