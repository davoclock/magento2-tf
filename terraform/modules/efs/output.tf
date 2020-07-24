output "efs_hostname" {
  value       = aws_efs_file_system.pub.dns_name
}

output "efs_id" {
  value       = aws_efs_file_system.pub.id
}

output "efs_ap_id" {
  value       = aws_efs_access_point.pub-media.id
}