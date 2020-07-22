output "bastion_ip" {
  value       = module.ec2.bastion_ip
}

output "es_endpoint" {
  value       = module.es.es_endpoint
}