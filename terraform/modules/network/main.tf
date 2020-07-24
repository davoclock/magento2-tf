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
  tags = {
    Name = "bastion servers subnet"
  }
}

resource "aws_subnet" "cache_subnets" {
  count                   = length(var.cache_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cache_subnets[count.index]
  availability_zone       = var.az[count.index]
  depends_on              = [aws_vpc.vpc]
  tags = {
    Name = "varnish servers subnet"
  }
}

resource "aws_subnet" "web_subnets" {
  count                   = length(var.web_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.web_subnets[count.index]
  availability_zone       = var.az[count.index]
  depends_on              = [aws_vpc.vpc]
  tags = {
    Name = "web servers subnet"
  }
}

resource "aws_subnet" "db_subnets" {
  count                   = length(var.db_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.db_subnets[count.index]
  availability_zone       = var.az[count.index]
  depends_on              = [aws_vpc.vpc]
  tags = {
    Name = "Database subnet"
  }
}

resource "aws_subnet" "search_subnets" {
  count                   = length(var.search_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.search_subnets[count.index]
  availability_zone       = var.az[count.index]
  depends_on              = [aws_vpc.vpc]
  tags = {
    Name = "Elasitcsearch subnet"
  }
}

resource "aws_subnet" "efs_subnets" {
  count                   = length(var.efs_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.efs_subnets[count.index]
  availability_zone       = var.az[count.index]
  depends_on              = [aws_vpc.vpc]
  tags = {
    Name = "EFS subnet"
  }
}

resource "aws_subnet" "redis_subnets" {
  count                   = length(var.redis_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.redis_subnets[count.index]
  availability_zone       = var.az[count.index]
  depends_on              = [aws_vpc.vpc]
  tags = {
    Name = "Redis subnet"
  }
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

#-------------------------------------------BASTION HOST SECURITY GROUP
resource "aws_security_group" "bastion_servers_sg" {
  name        = "BASTION"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#------------------------------------------- PUB LB SECURITY GROUP
resource "aws_security_group" "external_lb_sg" {
  name        = "PUBLB"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#-------------------------------------------VARNISH/CACHE SECURITY GROUP
resource "aws_security_group" "cache_servers_sg" {
  name        = "Cache"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.external_lb_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_servers_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#------------------------------------------- PRIV LB SECURITY GROUP
resource "aws_security_group" "internal_lb_sg" {
  name        = "PRIVLB"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.cache_servers_sg.id]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.cache_servers_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#-------------------------------------------MAGENTO/WEB SECURITY GROUP
resource "aws_security_group" "web_servers_sg" {
  name        = "Web"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.internal_lb_sg.id]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.internal_lb_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_servers_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#-------------------------------------------DB SECURITY GROUP
resource "aws_security_group" "rds_sg" {
  name        = "DB"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.web_servers_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#-------------------------------------------SEARCH SECURITY GROUP
resource "aws_security_group" "search_sg" {
  name        = "Search"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.web_servers_sg.id,aws_security_group.bastion_servers_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#-------------------------------------------REDIS SECURITY GROUP
resource "aws_security_group" "redis_sg" {
  name        = "Redis"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    security_groups = [aws_security_group.web_servers_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#-------------------------------------------REDIS SECURITY GROUP
resource "aws_security_group" "efs_sg" {
  name        = "EFS"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    security_groups = [aws_security_group.web_servers_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#-------------------------------------------DB SUBNET GROUP
resource "aws_db_subnet_group" "db_subnet_group" {
  name = "db subnet group"
  subnet_ids = [aws_subnet.db_subnets[0].id, aws_subnet.db_subnets[1].id]
}

#-------------------------------------------REDIS SUBNET GROUP
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = [aws_subnet.redis_subnets[0].id,aws_subnet.redis_subnets[1].id]
}

#------------------------------------------- VARNISH EXTERNAL LOAD BALANCER
resource "aws_lb" "varnish-lb" {
  name               = "varnish-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.external_lb_sg.id]
  subnets            = [aws_subnet.cache_subnets[0].id,aws_subnet.cache_subnets[1].id]
}

resource "aws_lb_target_group" "varnish-tg" {
  name     = "varnish-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  target_type = "ip"
  depends_on   = [aws_lb.varnish-lb]
}

resource "aws_lb_listener" "varnish-lb-listener" {
  load_balancer_arn = aws_lb.varnish-lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.ssl_cert_arn
  depends_on        = [aws_lb_target_group.varnish-tg,aws_lb.varnish-lb]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.varnish-tg.arn
  }
}


#------------------------------------------- MAGENTO INTERNAL LOAD BALANCER
resource "aws_lb" "magento-lb" {
  name               = "magento-load-balancer"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internal_lb_sg.id]
  subnets            = [aws_subnet.web_subnets[0].id,aws_subnet.web_subnets[1].id]
}

resource "aws_lb_target_group" "magento-tg" {
  name     = "magento-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  target_type = "ip"
  depends_on   = [aws_lb.magento-lb]
}

resource "aws_lb_listener" "magento-lb-listener" {
  load_balancer_arn = aws_lb.magento-lb.arn
  port              = "80"
  protocol          = "HTTP"
  depends_on        = [aws_lb_target_group.magento-tg,aws_lb.magento-lb]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.magento-tg.arn
  }
}