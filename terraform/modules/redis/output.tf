output "session_cache_nodes" {
  value       = aws_elasticache_cluster.redis_session.cache_nodes
}

output "default_cache_nodes" {
  value       = aws_elasticache_cluster.redis_cache.cache_nodes
}
