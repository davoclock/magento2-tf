variable "region1" {
  type    = string
  default = "us-east-1"
}

variable "credentials" {
    type    = string
    default = "C:\\users\\david\\.aws\\credentials"
}

#============================== REGION 1 VARIABLES ==============================#
variable "vpc_cidr_block1" {
    type = string
    default = "10.10.0.0/16"
}

variable "az1" {
    type = list
    default = ["us-east-1a","us-east-1b"]
}

variable "bastion_subnets1" {
    type = list
    default = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "cache_subnets1" {
    type = list
    default = ["10.10.3.0/24", "10.10.4.0/24"]
}

variable "web_subnets1" {
    type = list
    default = ["10.10.5.0/24", "10.10.6.0/24"]
}

variable "db_subnets1" {
    type = list
    default = ["10.10.7.0/24", "10.10.8.0/24"]
}

variable "search_subnets1" {
    type = list
    default = ["10.10.9.0/24", "10.10.10.0/24"]
}

variable "efs_subnets1" {
    type = list
    default = ["10.10.11.0/24", "10.10.12.0/24"]
}

variable "redis_subnets1" {
    type = list
    default = ["10.10.13.0/24", "10.10.14.0/24"]
}