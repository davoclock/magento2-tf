# vpc.tf 
#------------------------------------------- DEFINE PROVIDE FOR REGION 1
provider "aws" {
  region                  = var.region1
  version                 = "~> 2.70"
  alias                   = "region1"
  shared_credentials_file = var.credentials
  profile                 = "region1"
}

#------------------------------------------- CREATE VPC
module "network1" {
  source = "./modules/vpc"

  #VPC
  cidr_block             = var.vpcCIDRblock1

  #SUBNETS
  bastion_subnets        = var.bastion_subnets1
  az                     = var.az1

  #IGW

  #PUBLIC ROUTING TABLE

  #PUBLIC DEFAULT ROUTE

  #PUBLIC ROUTING TABLE ASSOCIATIONS
  providers = {
    aws = aws.region1
  }
}