variable "region" {
  default = "us-east-1"
}

variable "credentials" {
    default = "C:\\users\\david\\.aws\\credentials"
}

#---------------------------------------------------- BASTION HOST AUTHORIZED KEY
variable "ssh_key" {
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1DsCJula8agiQVT5teybIXSDiW1gXq9W6vQpyKWYjsMHTbQo9WsPTM2eH02bVz2WELIo5WBnZWHyXR1n8r2XTNFuZLlyCsju4F+X88nmo0m5QOSZnrc4X6SIS2rqEM+tpbD5q0bHkmRiCe7zzFcQ9wiplZO+e4FuDlEN+RUJT+WsqnCklPSBtoml1jwOtpfICWD0sOwEBhnSC4FxMCUcG1pMPSxLyha0D1dacio1IDERWsyBrP0IFrPHEb5UFmKVBx9il2qqeDNTFlvKA5YaJ27tfFroltbT6GwGIu2rQH0zerBPBG8vApNPeVMP1zCqt1/hblRVU12poPzWOlE7WmuxkyWbrndIy67RtLk05TyfgUie0AmLySDb4vCOLT2p8xfT3lZL1rnDq1ruq5MVBCKrbS9ZzJc2vmGv2TmevdR+Uzi9k63R71MfMpqWg79ApbsJfulbeUZNfns5pCwWq4RGXmZubPG8yrugUY/JX7JA/71IuLgJYNs66Fmt+oMjwgUgIdJpKvES7OPr61LCSg/I/VWLGg2idjIeOAWCbZtF8kNeBFngHS8HZUzG5FuY3ZAH30Z7j7xP4BtqqVmN3x0ven8m06336JIq0LG73x7sGTx87j+7uejluyFKjm1GdlLDKGRaOGYaOvtWbdloIgeSj5ZIREb4+mcuGpY4kXw== davo@DESKTOP-7DPUA1F"
}

#---------------------------------------------------- BASTION HOST AMI SOURCE
variable "bastion_host_ami" {
    default = "ami-01311df3780ebd33e"
}

#----------------------------------------------------- VPC VARIABLE
variable "vpc_cidr_block" {
    type = string
    default = "10.10.0.0/16"
}

#----------------------------------------------------- AZ VARIABLE
variable "az" {
    type = list
    default = ["us-east-1a","us-east-1b"]
}

#----------------------------------------------------- SUBNET VARIABLES
variable "bastion_subnets" {
    type = list
    default = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "cache_subnets" {
    type = list
    default = ["10.10.3.0/24", "10.10.4.0/24"]
}

variable "web_subnets" {
    type = list
    default = ["10.10.5.0/24", "10.10.6.0/24"]
}

variable "db_subnets" {
    type = list
    default = ["10.10.7.0/24", "10.10.8.0/24"]
}

variable "search_subnets" {
    type = list
    default = ["10.10.9.0/24", "10.10.10.0/24"]
}

variable "efs_subnets" {
    type = list
    default = ["10.10.11.0/24", "10.10.12.0/24"]
}

variable "redis_subnets" {
    type = list
    default = ["10.10.13.0/24", "10.10.14.0/24"]
}


#----------------------------------------------------- ELASTICSEARCH VARIABLES
variable "es_domain" {
  default = "magento"
}

variable "es_size" {
  default = "t2.small.elasticsearch"
}

variable "es_count" {
  default = "1"
}
variable "es_dedicated_master" {
  default = false
}
variable "es_version" {
  default = "7.4"
}

#----------------------------------------------------- REDIS VARIABLES
variable "redis_session_size" {
  default = "cache.t2.micro"
}

variable "redis_cache_size" {
  default = "cache.t2.micro"
}
