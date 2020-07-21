resource "aws_db_parameter_group" "magento_param_group" {
  name   = "mariadb"
  family = "mariadb10.4"
  parameter {
    name  = "binlog_format"
    value = "row"
  }
}
  resource "aws_db_instance" "magento" {
  identifier           = "magentodb"
  allocated_storage    = 10
  max_allocated_storage = 100
  storage_type         = "gp2"
  engine               = "mariadb"
  engine_version       = "10.4.13"
  instance_class       = "db.t2.micro"
  name                 = "magento"
  username             = "magento"
  password             = "magentomagento"
  parameter_group_name = "mariadb"
  multi_az              = true
  db_subnet_group_name  = var.db_subnet_group
  vpc_security_group_ids = [var.db_security_group_id]
  skip_final_snapshot   = true
  apply_immediately     = true
  depends_on = [aws_db_parameter_group.magento_param_group]
}