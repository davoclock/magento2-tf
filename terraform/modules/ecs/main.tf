resource "aws_ecs_cluster" "magento" {
  name = "magento"
  capacity_providers  = ["FARGATE","FARGATE_SPOT"]
}

resource "aws_ecs_task_definition" "magento-web" {
  family                = "magento-web"
  container_definitions = file("./task-definitions/magento-web.json")
  network_mode          = "awsvpc"
  requires_compatibilities  = ["FARGATE"]
  cpu         = 1024
  memory      = 2048

  volume {
    name = "service-storage"
    efs_volume_configuration {
      file_system_id          = var.efs_id
    }
  }
}


resource "aws_ecs_service" "magento-web" {
  name            = "magento-web"
  cluster         = aws_ecs_cluster.magento.id
  task_definition = aws_ecs_task_definition.magento-web.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  platform_version  = "1.4.0"

  load_balancer {
    target_group_arn = var.magento_tg_arn
    container_name   = "magento-web"
    container_port   = 80
  }

  network_configuration {
    subnets         = [var.web_subnet_id_a,var.web_subnet_id_b]
    security_groups  = [var.web_security_group_id]
  }
}