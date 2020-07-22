#------------------------------------------- DEFINE PROVIDER FOR REGION 1
provider "aws" {
  region                  = var.region
  version                 = "~> 2.70"
  shared_credentials_file = var.credentials
  profile                 = "magento2-tf"
}

#------------------------------------------- CREATE NETWORK COMPONENTS
module "network" {
  source = "./modules/vpc"

  #VPC
  cidr_block             = var.vpc_cidr_block

  #SUBNETS
  bastion_subnets        = var.bastion_subnets
  cache_subnets          = var.cache_subnets
  web_subnets            = var.web_subnets
  db_subnets             = var.db_subnets
  search_subnets         = var.search_subnets
  efs_subnets            = var.efs_subnets
  redis_subnets          = var.redis_subnets
  az                     = var.az
}

module "efs" {
  source = "./modules/efs"

  efs_subnets_id_a        = module.network.efs_subnets_id_1
  efs_subnets_id_b        = module.network.efs_subnets_id_2
  efs_security_group_id   = module.network.efs_security_group_id
}

module "ec2" {
  source = "./modules/ec2"

  #EC2 KEY PAIR
  ssh_key = var.ssh_key

  #BASTION HOST AMI
  bastion_host_ami        = var.bastion_host_ami
  bastion_host_sg         = module.network.bastion_security_group_id
  subnet_id               = module.network.bastion_subnets_id_1
}

module "rds" {
  source = "./modules/rds"
  db_subnet_group = module.network.aws_db_subnet_group
  db_security_group_id = module.network.db_security_group_id
}

module "es" {
  source = "./modules/elasticsearch"

  es_domain           = var.es_domain
  es_size             = var.es_size
  es_version          = var.es_version
  es_count            = var.es_count
  es_dedicated_master = var.es_dedicated_master
  es_subnet_id_a      = module.network.search_subnets_id_a
  es_subnet_id_b      = module.network.search_subnets_id_b
  es_security_group_id= module.network.es_security_group_id
}

module "ecr" {
  source = "./modules/ecr"
}