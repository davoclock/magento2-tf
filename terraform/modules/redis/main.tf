
resource "aws_elasticache_cluster" "redis_session" {
  cluster_id           = "magento-sessions"
  engine               = "redis"
  node_type            = var.redis_session_size
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.6"
  security_group_ids   = [var.redis_security_group_id]
  apply_immediately    = true
  subnet_group_name    = var.redis_subnet_group_name
  port                 = 6379
}

resource "aws_elasticache_cluster" "redis_cache" {
  cluster_id           = "magento-cache"
  engine               = "redis"
  node_type            = var.redis_cache_size
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.6"
  security_group_ids   = [var.redis_security_group_id]
  apply_immediately    = true
  subnet_group_name    = var.redis_subnet_group_name
  port                 = 6379
}