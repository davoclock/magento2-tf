output "efs_hostname" {
  value       = aws_efs_file_system.pub.dns_name
}

output "efs_id" {
  value       = aws_efs_file_system.pub.id
}