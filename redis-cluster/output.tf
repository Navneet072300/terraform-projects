
output "elasticache_cluster_endpoint" {
  value       = aws_elasticache_cluster.redisdb.arn
}