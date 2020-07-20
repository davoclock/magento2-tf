resource "aws_efs_file_system" "pub" {
  creation_token = "pub-media"
  tags = {
    Name = "pub/media"
  }
}

resource "aws_efs_mount_target" "puba" {
  file_system_id  = aws_efs_file_system.pub.id
  subnet_id       = var.efs_subnets_id_a
  security_groups = [var.efs_security_group_id]
  depends_on      = [aws_efs_file_system.pub]
}

resource "aws_efs_mount_target" "pubb" {
  file_system_id  = aws_efs_file_system.pub.id
  subnet_id       = var.efs_subnets_id_b
  security_groups = [var.efs_security_group_id]
  depends_on      = [aws_efs_file_system.pub]
}