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



#-------------------------------------------- ECS MAGENTO TASK EXECUTION ROLES & POLICY ATTACHMENT
data "aws_iam_policy_document" "assume_ecs_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecswebTaskExecutionRole" {
  name               = "ecs-web-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_ecs_policy.json
}

resource "aws_iam_role_policy_attachment" "ecswebTaskExecutionRole_policy" {
  role       = aws_iam_role.ecswebTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#-------------------------------------------- ECS VARNISH TASK EXECUTION ROLES & POLICY ATTACHMENT
resource "aws_iam_role" "ecsvarnishTaskExecutionRole" {
  name               = "ecs-varnish-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_ecs_policy.json
}

resource "aws_iam_role_policy_attachment" "ecsvarnishTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsvarnishTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}