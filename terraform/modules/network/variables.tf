variable "cidr_block" {}
variable "bastion_subnets" {type = list}
variable "cache_subnets" {type = list}
variable "web_subnets" {type = list}
variable "db_subnets" {type = list}
variable "search_subnets" {type = list}
variable "efs_subnets" {type = list}
variable "redis_subnets" {type = list}
variable "az" {}
variable "ssl_cert_arn" {}