#------------------------------------------- DEFINE PROVIDER FOR REGION 2
provider "aws" {
  region                  = var.region2
  version                 = "~> 2.70"
  alias                   = "region2"
  shared_credentials_file = var.credentials
  profile                 = "region2"
}

#------------------------------------------- VPC PEERING
resource "aws_vpc_peering_connection" "cross-region-peering" {
  provider      = aws.region1
  vpc_id        = module.network1.vpc_id
  peer_vpc_id   = module.network2.vpc_id
  peer_region   = var.region2
  auto_accept   = false
  depends_on    = [module.network1,module.network2]
}

resource "aws_vpc_peering_connection_accepter" "cross-region-peering" {
  provider                  = aws.region2
  vpc_peering_connection_id = aws_vpc_peering_connection.cross-region-peering.id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_options" "requester" {
  provider = aws.region1
  vpc_peering_connection_id = aws_vpc_peering_connection.cross-region-peering.id
  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection_options" "accepter" {
  provider = aws.region2
  vpc_peering_connection_id = aws_vpc_peering_connection.cross-region-peering.id
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
  depends_on      = [aws_vpc_peering_connection.cross-region-peering,aws_vpc_peering_connection_accepter.cross-region-peering]
}

#-------------------------------------------  VPC PEERING ROUTES
resource "aws_route" "region1_to_region2_route" {
  provider                  = aws.region1
  route_table_id            = module.network1.private_routing_table_id
  destination_cidr_block    = var.vpc_cidr_block2
  vpc_peering_connection_id = aws_vpc_peering_connection.cross-region-peering.id
  depends_on                = [aws_vpc_peering_connection.cross-region-peering]
}

resource "aws_route" "region2_to_region1_route" {
  provider                  = aws.region2
  route_table_id            = module.network2.private_routing_table_id
  destination_cidr_block    = var.vpc_cidr_block1
  vpc_peering_connection_id = aws_vpc_peering_connection.cross-region-peering.id
  depends_on                = [aws_vpc_peering_connection.cross-region-peering]
}


#------------------------------------------- CREATE NETWORK COMPONENTS
module "network2" {
  source = "./modules/vpc"

  #VPC
  cidr_block             = var.vpc_cidr_block2

  #SUBNETS
  bastion_subnets        = var.bastion_subnets2
  cache_subnets          = var.cache_subnets2
  web_subnets            = var.web_subnets2
  db_subnets             = var.db_subnets2
  search_subnets         = var.search_subnets2
  efs_subnets            = var.efs_subnets2
  redis_subnets          = var.redis_subnets2
  az                     = var.az2

  #IGW

  #PUBLIC ROUTING TABLE

  #PUBLIC DEFAULT ROUTE

  #PUBLIC ROUTING TABLE ASSOCIATIONS
  providers = {
    aws = aws.region2
  }
}

module "efs2" {
  source = "./modules/efs"

  efs_subnets_id_a        = module.network2.efs_subnets_id_1
  efs_subnets_id_b        = module.network2.efs_subnets_id_2
  efs_security_group_id   = module.network2.efs_security_group_id
  
  providers = {
    aws = aws.region2
  }
}

