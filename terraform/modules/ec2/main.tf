resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion_key"
  public_key = var.ssh_key
}

data "aws_ami" "al2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20200617.0-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners =["137112412989"]
}


resource "aws_instance" "bastion_host" {
  ami           = data.aws_ami.al2.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.bastion_key.key_name
  vpc_security_group_ids = [var.bastion_host_sg]
  subnet_id       = var.subnet_id
  associate_public_ip_address = true
  iam_instance_profile = var.bastion_profile

  tags = {
    Name = "Bastion Host"
  }
}