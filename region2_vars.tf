variable "region2" {
  type    = string
  default = "us-west-2"
}






#============================== REGION 2 VARIABLES ==============================#
variable "vpcCIDRblock2" {
    type = string
    default = "10.20.0.0/16"
}

variable "az2" {
    type = list
    default = ["a","b"]
}

variable "bastion_subnets2" {
    type = list
    default = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "cache_subnets2" {
    type = list
    default = ["10.20.3.0/24", "10.20.4.0/24"]
}

variable "web_subnets2" {
    type = list
    default = ["10.20.5.0/24", "10.20.6.0/24"]
}

variable "db_subnets2" {
    type = list
    default = ["10.20.7.0/24", "10.20.8.0/24"]
}

variable "search_subnets2" {
    type = list
    default = ["10.20.9.0/24", "10.20.10.0/24"]
}

variable "efs_subnets2" {
    type = list
    default = ["10.20.11.0/24", "10.20.12.0/24"]
}

variable "redis_subnets2" {
    type = list
    default = ["10.20.13.0/24", "10.20.14.0/24"]
}