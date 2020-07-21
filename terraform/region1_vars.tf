variable "region1" {
  type    = string
  default = "us-east-1"
}

variable "credentials" {
    type    = string
    default = "C:\\users\\david\\.aws\\credentials"
}

#---------------------------------------------------- BASTION HOST AUTHORIZED KEY
variable "ssh_key1" {
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1DsCJula8agiQVT5teybIXSDiW1gXq9W6vQpyKWYjsMHTbQo9WsPTM2eH02bVz2WELIo5WBnZWHyXR1n8r2XTNFuZLlyCsju4F+X88nmo0m5QOSZnrc4X6SIS2rqEM+tpbD5q0bHkmRiCe7zzFcQ9wiplZO+e4FuDlEN+RUJT+WsqnCklPSBtoml1jwOtpfICWD0sOwEBhnSC4FxMCUcG1pMPSxLyha0D1dacio1IDERWsyBrP0IFrPHEb5UFmKVBx9il2qqeDNTFlvKA5YaJ27tfFroltbT6GwGIu2rQH0zerBPBG8vApNPeVMP1zCqt1/hblRVU12poPzWOlE7WmuxkyWbrndIy67RtLk05TyfgUie0AmLySDb4vCOLT2p8xfT3lZL1rnDq1ruq5MVBCKrbS9ZzJc2vmGv2TmevdR+Uzi9k63R71MfMpqWg79ApbsJfulbeUZNfns5pCwWq4RGXmZubPG8yrugUY/JX7JA/71IuLgJYNs66Fmt+oMjwgUgIdJpKvES7OPr61LCSg/I/VWLGg2idjIeOAWCbZtF8kNeBFngHS8HZUzG5FuY3ZAH30Z7j7xP4BtqqVmN3x0ven8m06336JIq0LG73x7sGTx87j+7uejluyFKjm1GdlLDKGRaOGYaOvtWbdloIgeSj5ZIREb4+mcuGpY4kXw== davo@DESKTOP-7DPUA1F"
}

#---------------------------------------------------- BASTION HOST AMI SOURCE
variable "bastion_host_ami1" {
    default = "ami-01311df3780ebd33e"
}

#----------------------------------------------------- VPC VARIABLE
variable "vpc_cidr_block1" {
    type = string
    default = "10.10.0.0/16"
}

#----------------------------------------------------- AZ VARIABLE
variable "az1" {
    type = list
    default = ["us-east-1a","us-east-1b"]
}

#----------------------------------------------------- SUBNET VARIABLES
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


#----------------------------------------------------- ELASTICSEARCH VARIABLES
variable "es_domain1" {
  default = "magento"
}

variable "es_size1" {
  default = "t2.small.elasticsearch"
}

variable "es_count1" {
  default = "1"
}
variable "es_dedicated_master1" {
  default = false
}
variable "es_version1" {
  default = "7.4"
}
