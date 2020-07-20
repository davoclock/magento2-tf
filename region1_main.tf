#------------------------------------------- DEFINE PROVIDER FOR REGION 1
provider "aws" {
  region                  = var.region1
  version                 = "~> 2.70"
  alias                   = "region1"
  shared_credentials_file = var.credentials
  profile                 = "region1"
}

#------------------------------------------- CREATE NETWORK COMPONENTS
module "network1" {
  source = "./modules/vpc"

  #VPC
  cidr_block             = var.vpc_cidr_block1

  #SUBNETS
  bastion_subnets        = var.bastion_subnets1
  cache_subnets          = var.cache_subnets1
  web_subnets            = var.web_subnets1
  db_subnets             = var.db_subnets1
  search_subnets         = var.search_subnets1
  efs_subnets            = var.efs_subnets1
  redis_subnets          = var.redis_subnets1
  az                     = var.az1

  #IGW

  #PUBLIC ROUTING TABLE

  #PUBLIC DEFAULT ROUTE

  #PUBLIC ROUTING TABLE ASSOCIATIONS
  providers = {
    aws = aws.region1
  }
}

module "efs1" {
  source = "./modules/efs"

  efs_subnets_id_a        = module.network1.efs_subnets_id_1
  efs_subnets_id_b        = module.network1.efs_subnets_id_2
  efs_security_group_id   = module.network1.efs_security_group_id

  providers = {
    aws = aws.region1
  }
}