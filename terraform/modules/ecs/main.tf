resource "aws_ecs_cluster" "magento" {
  name = "magento"
  capacity_providers  = ["FARGATE","FARGATE_SPOT"]
}

resource "aws_ecs_task_definition" "magento-web" {
  family                = "magento-web"
  execution_role_arn = var.web_task_execution_role
  container_definitions = <<TASK_DEFINITION
[
    {
      "name": "magento-web",
      "image": "${var.ecr_magento_url}:latest",
      "cpu": 1024,
      "memory": 2048,
      "networkMode": "awsvpc",
      "essential": true,
      "mountPoints": [
        {
          "readOnly": null,
          "containerPath": "/var/www/html/magento2/pub/media",
          "sourceVolume": "pubmedia"
        }
      ],
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        },
        {
            "containerPort": 22,
            "hostPort": 22
        }
      ]
    }
  ]
TASK_DEFINITION

  network_mode          = "awsvpc"
  requires_compatibilities  = ["FARGATE"]
  cpu         = 1024
  memory      = 2048

  volume {
    name = "pubmedia"
    efs_volume_configuration {
      transit_encryption      = "ENABLED"
      file_system_id          = var.efs_id
      authorization_config {
        access_point_id = var.efs_ap_id
      }
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

#------------------------------------------------- VARNISH
resource "aws_ecs_cluster" "varnish" {
  name = "varnish"
  capacity_providers  = ["FARGATE","FARGATE_SPOT"]
}

resource "aws_ecs_task_definition" "varnish-cache" {
  family                = "varnish-cache"
  execution_role_arn = var.varnish_task_execution_role
  container_definitions = <<TASK_DEFINITION
[
    {
      "name": "varnish",
      "image": "${var.ecr_varnish_url}:latest",
      "cpu": 256,
      "memory": 512,
      "networkMode": "awsvpc",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ]
    }
  ]
TASK_DEFINITION

  network_mode          = "awsvpc"
  requires_compatibilities  = ["FARGATE"]
  cpu         = 256
  memory      = 512
}

resource "aws_ecs_service" "varnish-cache" {
  name            = "varnish-cache"
  cluster         = aws_ecs_cluster.varnish.id
  task_definition = aws_ecs_task_definition.varnish-cache.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  platform_version  = "1.4.0"

  load_balancer {
    target_group_arn = var.varnish_tg_arn
    container_name   = "varnish"
    container_port   = 80
  }

  network_configuration {
    subnets         = [var.cache_subnet_id_a,var.cache_subnet_id_b]
    security_groups  = [var.cache_security_group_id]
  }
}