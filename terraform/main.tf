#------------------------------------------- DEFINE PROVIDER FOR REGION 1
provider "aws" {
  region                  = var.region
  version                 = "~> 2.70"
  shared_credentials_file = var.credentials
  profile                 = "magento2-tf"
}

#------------------------------------------- CREATE NETWORK COMPONENTS
module "network" {
  source = "./modules/network"

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
  ssl_cert_arn           = var.ssl_cert_arn
}

#------------------------------------------- IAM ROLES
module "iam" {
  source = "./modules/iam"
}

module "efs" {
  source = "./modules/efs"

  #EFS OPTIONS
  efs_subnets_id_a        = module.network.efs_subnets_id_a
  efs_subnets_id_b        = module.network.efs_subnets_id_b
  efs_security_group_id   = module.network.efs_security_group_id
}

module "ec2" {
  source = "./modules/ec2"

  #EC2 KEY PAIR
  ssh_key = var.ssh_key

  #BASTION HOST OPTIONS
  bastion_host_sg         = module.network.bastion_security_group_id
  subnet_id               = module.network.bastion_subnets_id_a
  bastion_host_ami        = var.bastion_host_ami
  bastion_profile         = module.iam.bastion_profile
}

module "rds" {
  source = "./modules/rds"

  #RDS OPTIONS
  rds_subnet_group = module.network.aws_db_subnet_group_name
  rds_security_group_id = module.network.db_security_group_id
  rds_disk_size       = var.rds_disk_size
  rds_max_disk_size   = var.rds_max_disk_size
  rds_type            = var.rds_type
}

module "es" {
  source = "./modules/elasticsearch"

  #ELASTICSEARCH OPTIONS
  es_subnet_id_a      = module.network.search_subnets_id_a
  es_subnet_id_b      = module.network.search_subnets_id_b
  es_security_group_id= module.network.es_security_group_id
  es_domain           = var.es_domain
  es_size             = var.es_size
  es_version          = var.es_version
  es_count            = var.es_count
  es_dedicated_master = var.es_dedicated_master
}

module "redis" {
  source = "./modules/redis"

  #REDIS OPTIONS
  redis_subnet_group_name      = module.network.aws_redis_subnet_group_name
  redis_security_group_id      = module.network.redis_security_group_id
  redis_session_size           = var.redis_session_size  
  redis_cache_size             = var.redis_cache_size
}

module "ecr" {
  source = "./modules/ecr"
}

module "ecs" {
  source = "./modules/ecs"

  task_execution_role = module.iam.ecs_web_task_execution_role_arn
  efs_id = module.efs.efs_id
  magento_tg_arn  = module.network.magento_tg_arn
  region        = var.region
  web_subnet_id_a = module.network.web_subnets_id_a
  web_subnet_id_b = module.network.web_subnets_id_b
  web_security_group_id  = module.network.web_security_group_id
  ecr_magento_url         = module.ecr.ecr_magento_url
}