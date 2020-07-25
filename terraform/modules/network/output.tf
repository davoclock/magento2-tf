#----------------------------------------------------- VPC ID
output "vpc_id" {
  value       = aws_vpc.vpc.id
}

#----------------------------------------------------- SUBNET IDS
output "bastion_subnets_id_a" {
  value       = aws_subnet.bastion_subnets[0].id
}

output "bastion_subnets_id_b" {
  value       = aws_subnet.bastion_subnets[1].id
}

output "cache_subnets_id_a" {
  value       = aws_subnet.cache_subnets[0].id
}

output "cache_subnets_id_b" {
  value       = aws_subnet.cache_subnets[1].id
}

output "web_subnets_id_a" {
  value       = aws_subnet.web_subnets[0].id
}

output "web_subnets_id_b" {
  value       = aws_subnet.web_subnets[1].id
}

output "db_subnets_id_a" {
  value       = aws_subnet.db_subnets[0].id
}

output "db_subnets_id_b" {
  value       = aws_subnet.db_subnets[1].id
}

output "search_subnets_id_a" {
  value       = aws_subnet.search_subnets[0].id
}

output "search_subnets_id_b" {
  value       = aws_subnet.search_subnets[1].id
}

output "efs_subnets_id_a" {
  value       = aws_subnet.efs_subnets[0].id
}

output "efs_subnets_id_b" {
  value       = aws_subnet.efs_subnets[1].id
}

output "redis_subnets_id_a" {
  value       = aws_subnet.redis_subnets[0].id
}

output "redis_subnets_id_b" {
  value       = aws_subnet.redis_subnets[1].id
}

#----------------------------------------------------- IGW ID
output "internet_gateway_id" {
  value       = aws_internet_gateway.internet_gateway.id
}

#----------------------------------------------------- ROUTING TABLE IDS
output "public_routing_table_id" {
  value       = aws_route_table.public_routing_table.id
}

output "private_routing_table_id" {
  value       = aws_route_table.private_routing_table.id
}

#----------------------------------------------------- SECURITY GROUP IDs
output "efs_security_group_id" {
  value       = aws_security_group.efs_sg.id
}

output "bastion_security_group_id" {
  value       = aws_security_group.bastion_servers_sg.id
}

output "db_security_group_id" {
  value       = aws_security_group.rds_sg.id
}

output "es_security_group_id" {
  value       = aws_security_group.search_sg.id
}

output "redis_security_group_id" {
  value       = aws_security_group.redis_sg.id
}

output "web_security_group_id" {
  value       = aws_security_group.web_servers_sg.id
}

output "cache_security_group_id" {
  value       = aws_security_group.cache_servers_sg.id
}

#----------------------------------------------------- DB SUBNET GROUP NAME
output "aws_db_subnet_group_name" {
  value       = aws_db_subnet_group.db_subnet_group.name
}

#----------------------------------------------------- REDIS SUBNET GROUP NAME
output "aws_redis_subnet_group_name" {
  value       = aws_elasticache_subnet_group.redis_subnet_group.name
}

#----------------------------------------------------- ALB ARNs
output "magento_lb" {
  value       = aws_lb.magento-lb.arn
}

output "varnish_lb" {
    value      = aws_lb.varnish-lb.arn
}

#----------------------------------------------------- MAGENTO TARGET GROUP ARN
output "magento_tg_arn" {
    value      = aws_lb_target_group.magento-tg.arn
}

#----------------------------------------------------- VARNISH TARGET GROUP ARN
output "varnish_tg_arn" {
    value      = aws_lb_target_group.varnish-tg.arn
}