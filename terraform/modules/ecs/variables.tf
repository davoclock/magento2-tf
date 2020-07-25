#---------------------------- MAGENTO VARIALBES
variable "magento_tg_arn" {}
variable "region" {}
variable "efs_id" {}
variable "web_task_execution_role" {}
variable "web_subnet_id_a" {}
variable "web_subnet_id_b" {}
variable "web_security_group_id" {}
variable "ecr_magento_url" {}
variable "efs_ap_id" {}

#----------------------------- VARNISH VARIABLES
variable "varnish_tg_arn" {}
variable "cache_subnet_id_a" {}
variable "cache_subnet_id_b" {}
variable "cache_security_group_id" {}
variable "ecr_varnish_url" {}
variable "varnish_task_execution_role" {}