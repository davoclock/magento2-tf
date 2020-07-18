#------------------------------------------- CREATE VPC

resource "aws_vpc" "vpc" {
  cidr_block          = var.cidr_block
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
}

#------------------------------------------- CREATE SUBNETS
resource "aws_subnet" "bastion_subnets" {
  count                   = length(var.bastion_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.bastion_subnets[count.index]
  availability_zone       = var.az[count.index]
}

#------------------------------------------- CREATE IGW
resource "aws_internet_gateway" "internet_gateway" {
 vpc_id = aws_vpc.vpc.id
}

#------------------------------------------- PUBLIC ROUTING TABLE
resource "aws_route_table" "public_routing_table" {
 vpc_id = aws_vpc.vpc.id
} 

#------------------------------------------- PRIVATE ROUTING TABLE
resource "aws_route_table" "private_routing_table" {
 vpc_id = aws_vpc.vpc.id
} 

#------------------------------------------- PUBLIC ROUTING TABLE - DEFAULT ROUTE
resource "aws_route" "public_default_route" {
  route_table_id         = aws_route_table.public_routing_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

#------------------------------------------- PRIVATE ROUTING TABLE - DEFAULT ROUTE
resource "aws_route" "private_default_route" {
  route_table_id         = aws_route_table.private_routing_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat_gateway.id
}

#------------------------------------------- CREATE PUBLIC ROUTING TABLE ASSOCIATIONS
resource "aws_route_table_association" "public_rt_associations" {
  count          = length(var.bastion_subnets)
  subnet_id      = aws_subnet.bastion_subnets[count.index].id
  route_table_id = aws_route_table.public_routing_table.id
}

#------------------------------------------- CREATE ELASTIC IP FOR NAT GW
resource "aws_eip" "elastic_ip_for_nat" {
  vpc = true
  depends_on     = [aws_internet_gateway.internet_gateway]
}

#------------------------------------------- ATTACH ELASTIC IP TO PUBLIC SUBNET
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip_for_nat.id
  subnet_id     = aws_subnet.bastion_subnets[0].id

}