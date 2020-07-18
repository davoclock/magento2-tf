#------------------------------------------- DEFINE PROVIDER FOR REGION 2
provider "aws" {
  region                  = var.region2
  version                 = "~> 2.70"
  alias                   = "region2"
  shared_credentials_file = var.credentials
  profile                 = "region2"
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