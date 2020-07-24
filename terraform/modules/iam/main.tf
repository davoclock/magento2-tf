#-------------------------------------------- BASTION IAM ROLES & POLICIES
resource "aws_iam_role" "bastion_role" {
  name = "bastion_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    },
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "sts.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "bastion_profile"
  role = aws_iam_role.bastion_role.name
}

resource "aws_iam_role_policy" "bastion_policy" {
  name = "bastion_policy"
  role = aws_iam_role.bastion_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:*",
        "ec2:*",
        "rds:*",
        "es:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}



#-------------------------------------------- ECS MAGENTO TASK WEB ROLES & POLICIES
resource "aws_iam_role" "web_ecs_task_role" {
  name = "web_ecs_task_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "web_ecs_task_attachment" {
  name       = "ECSTaskExecutionRolePolicyt"
  roles      = [aws_iam_role.web_ecs_task_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#-------------------------------------------- ECS MAGENTO SERVICE WEB ROLES & POLICIES
resource "aws_iam_role" "web_ecs_service_role" {
  name = "web_ecs_service_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}