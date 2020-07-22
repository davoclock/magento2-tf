output "bastion_ip" {
  value       = module.ec2.bastion_ip
}

output "es_endpoint" {
  value       = module.es.es_endpoint
}

output "redis_session_endpoint" {
  value       = module.redis.session_cache_nodes
}

output "redis_cache_endpoint" {
  value       = module.redis.default_cache_nodes
}