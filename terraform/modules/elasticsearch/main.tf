resource "aws_iam_service_linked_role" "es_linked_role" {
  aws_service_name = "es.amazonaws.com"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_elasticsearch_domain" "es" {
  domain_name           = var.es_domain
  elasticsearch_version = var.es_version

  cluster_config {
    instance_type = var.es_size
    instance_count = var.es_count
    dedicated_master_enabled = var.es_dedicated_master
  }

  vpc_options {
    subnet_ids = [var.es_subnet_id_a]
    security_group_ids = [var.es_security_group_id]
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.es_domain}/*"
        }
    ]
}
CONFIG

  depends_on = [aws_iam_service_linked_role.es_linked_role]
}