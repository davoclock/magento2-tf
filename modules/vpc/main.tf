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
  depends_on              = [aws_vpc.vpc]
}

resource "aws_subnet" "cache_subnets" {
  count                   = length(var.cache_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cache_subnets[count.index]
  availability_zone       = var.az[count.index]
  depends_on              = [aws_vpc.vpc]
}

resource "aws_subnet" "web_subnets" {
  count                   = length(var.web_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.web_subnets[count.index]
  availability_zone       = var.az[count.index]
  depends_on              = [aws_vpc.vpc]
}

resource "aws_subnet" "db_subnets" {
  count                   = length(var.db_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.db_subnets[count.index]
  availability_zone       = var.az[count.index]
  depends_on              = [aws_vpc.vpc]
}

resource "aws_subnet" "search_subnets" {
  count                   = length(var.search_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.search_subnets[count.index]
  availability_zone       = var.az[count.index]
  depends_on              = [aws_vpc.vpc]
}

resource "aws_subnet" "efs_subnets" {
  count                   = length(var.efs_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.efs_subnets[count.index]
  availability_zone       = var.az[count.index]
  depends_on              = [aws_vpc.vpc]
}

resource "aws_subnet" "redis_subnets" {
  count                   = length(var.redis_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.redis_subnets[count.index]
  availability_zone       = var.az[count.index]
  depends_on              = [aws_vpc.vpc]
}
#------------------------------------------- CREATE IGW
resource "aws_internet_gateway" "internet_gateway" {
 vpc_id                   = aws_vpc.vpc.id
 depends_on               = [aws_vpc.vpc]
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
  depends_on             = [aws_vpc.vpc]
}

#------------------------------------------- PRIVATE ROUTING TABLE - DEFAULT ROUTE
resource "aws_route" "private_default_route" {
  route_table_id         = aws_route_table.private_routing_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id             = aws_nat_gateway.nat_gateway.id
}

#------------------------------------------- CREATE PUBLIC ROUTING TABLE ASSOCIATIONS
resource "aws_route_table_association" "dmz_rt_association" {
  count          = length(var.bastion_subnets)
  subnet_id      = aws_subnet.bastion_subnets[count.index].id
  route_table_id = aws_route_table.public_routing_table.id
}

#------------------------------------------- CREATE PRIVATE ROUTING TABLE ASSOCIATIONS
resource "aws_route_table_association" "cache_rt_association" {
  count          = length(var.cache_subnets)
  subnet_id      = aws_subnet.cache_subnets[count.index].id
  route_table_id = aws_route_table.private_routing_table.id
}

resource "aws_route_table_association" "web_rt_association" {
  count          = length(var.web_subnets)
  subnet_id      = aws_subnet.web_subnets[count.index].id
  route_table_id = aws_route_table.private_routing_table.id
}

resource "aws_route_table_association" "db_rt_association" {
  count          = length(var.db_subnets)
  subnet_id      = aws_subnet.db_subnets[count.index].id
  route_table_id = aws_route_table.private_routing_table.id
}

resource "aws_route_table_association" "search_rt_association" {
  count          = length(var.search_subnets)
  subnet_id      = aws_subnet.search_subnets[count.index].id
  route_table_id = aws_route_table.private_routing_table.id
}

resource "aws_route_table_association" "efs_rt_association" {
  count          = length(var.efs_subnets)
  subnet_id      = aws_subnet.efs_subnets[count.index].id
  route_table_id = aws_route_table.private_routing_table.id
}

resource "aws_route_table_association" "redis_rt_association" {
  count          = length(var.redis_subnets)
  subnet_id      = aws_subnet.redis_subnets[count.index].id
  route_table_id = aws_route_table.private_routing_table.id
}

#------------------------------------------- CREATE ELASTIC IP FOR NAT GW
resource "aws_eip" "elastic_ip_for_nat" {
  vpc = true
  depends_on     = [aws_internet_gateway.internet_gateway]
}

#------------------------------------------- ATTACH ELASTIC IP TO NAT GW
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip_for_nat.id
  subnet_id     = aws_subnet.bastion_subnets[0].id
  depends_on    = [aws_eip.elastic_ip_for_nat]
}