output "elasticache_cluster_endpoint" {
  value       = aws_elasticache_cluster.redis_db.cluster_address
  description = "The endpoint address of the ElastiCache Redis cluster"
}