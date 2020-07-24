output "bastion_profile" {
  value       = aws_iam_instance_profile.bastion_profile.name
}

output "ecs_web_task_execution_role_arn" {
  value       = aws_iam_role.web_ecs_task_role.arn
}

output "ecs_web_service_role_arn" {
  value       = aws_iam_role.web_ecs_service_role.arn
}