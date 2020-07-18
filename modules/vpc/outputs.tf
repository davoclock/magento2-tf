output "vpc_id" {
  value       = aws_vpc.vpc.id
}

output "bastion_subnets_id_1" {
  value       = aws_subnet.bastion_subnets[0].id
}

output "bastion_subnets_id_2" {
  value       = aws_subnet.bastion_subnets[1].id
}

output "cache_subnets_id_1" {
  value       = aws_subnet.cache_subnets[0].id
}

output "cache_subnets_id_2" {
  value       = aws_subnet.cache_subnets[1].id
}

output "web_subnets_id_1" {
  value       = aws_subnet.web_subnets[0].id
}

output "web_subnets_id_2" {
  value       = aws_subnet.web_subnets[1].id
}

output "db_subnets_id_1" {
  value       = aws_subnet.db_subnets[0].id
}

output "db_subnets_id_2" {
  value       = aws_subnet.db_subnets[1].id
}

output "search_subnets_id_1" {
  value       = aws_subnet.search_subnets[0].id
}

output "search_subnets_id_2" {
  value       = aws_subnet.search_subnets[1].id
}

output "efs_subnets_id_1" {
  value       = aws_subnet.efs_subnets[0].id
}

output "efs_subnets_id_2" {
  value       = aws_subnet.efs_subnets[1].id
}

output "redis_subnets_id_1" {
  value       = aws_subnet.redis_subnets[0].id
}

output "redis_subnets_id_2" {
  value       = aws_subnet.redis_subnets[1].id
}


output "internet_gateway_id" {
  value       = aws_internet_gateway.internet_gateway.id
}

output "public_routing_table_id" {
  value       = aws_route_table.public_routing_table.id
}

