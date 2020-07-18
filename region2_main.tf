# vpc.tf 
#------------------------------------------- DEFINE PROVIDE FOR REGION 1
provider "aws" {
  region                  = var.region2
  version                 = "~> 2.70"
  alias                   = "region2"
  shared_credentials_file = var.credentials
  profile                 = "region2"
}

#------------------------------------------- CREATE VPC
module "network2" {
  source = "./modules/vpc"

  #VPC
  cidr_block             = var.vpcCIDRblock2

  #SUBNETS
  bastion_subnets        = var.bastion_subnets2
  az                     = var.az2

  #IGW

  #PUBLIC ROUTING TABLE

  #PUBLIC DEFAULT ROUTE

  #PUBLIC ROUTING TABLE ASSOCIATIONS
  providers = {
    aws = aws.region2
  }
}