output "ecr_magento_url" {
  value       = aws_ecr_repository.magento.repository_url
}

output "ecr_varnish_url" {
  value       = aws_ecr_repository.varnish.repository_url
}