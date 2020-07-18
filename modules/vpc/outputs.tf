output "vpc_id" {
  value       = aws_vpc.vpc.id
}

output "bastion_subnets_id_1" {
  value       = aws_subnet.bastion_subnets[0].id
}

output "bastion_subnets_id_2" {
  value       = aws_subnet.bastion_subnets[1].id
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.internet_gateway.id
}

output "public_routing_table_id" {
  value       = aws_route_table.public_routing_table.id
}

