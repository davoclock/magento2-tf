resource "aws_ecr_repository" "magento" {
  name                 = "magento"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "varnish" {
  name                 = "varnish"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository_policy" "ecr_ecs_magento_policy" {
  repository = aws_ecr_repository.magento.name

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "ecr-policy-for-magento-tasks",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::661779315943:role/ecs-web-task-execution-role"
      },
      "Action": "ecr:*"
    }
  ]
}
EOF
}

resource "aws_ecr_repository_policy" "ecr_ecs_varnish_policy" {
  repository = aws_ecr_repository.varnish.name

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "ecr-policy-for-varnish-tasks",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::661779315943:role/ecs-varnish-task-execution-role"
      },
      "Action": "ecr:*"
    }
  ]
}
EOF
}