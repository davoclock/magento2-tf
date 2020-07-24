output "bastion_profile" {
  value       = aws_iam_instance_profile.bastion_profile.name
}

output "ecs_web_task_execution_role_arn" {
  value       = aws_iam_role.ecsTaskExecutionRole.arn
}