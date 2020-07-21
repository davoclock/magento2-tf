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

module "ec21" {
  source = "./modules/ec2"

  #EC2 KEY PAIR
  ssh_key = var.ssh_key1

  #BASTION HOST AMI
  bastion_host_ami        = var.bastion_host_ami1
  bastion_host_sg         = module.network1.bastion_security_group_id
  subnet_id               = module.network1.bastion_subnets_id_1

  providers = {
    aws = aws.region1
  }
}

module "rds1" {
  source = "./modules/rds"
  db_subnet_group = module.network1.aws_db_subnet_group
  db_security_group_id = module.network1.db_security_group_id

  providers = {
    aws = aws.region1
  }
}

module "es1" {
  source = "./modules/elasticsearch"

  es_domain           = var.es_domain1
  es_size             = var.es_size1
  es_version          = var.es_version1
  es_count            = var.es_count1
  es_dedicated_master = var.es_dedicated_master1
  es_subnet_id_a      = module.network1.search_subnets_id_a
  es_subnet_id_b      = module.network1.search_subnets_id_b
  es_security_group_id= module.network1.es_security_group_id

  providers = {
    aws = aws.region1
  }
}

module "ecr1" {
  source = "./modules/ecr"
  providers = {
    aws = aws.region1
  }
}