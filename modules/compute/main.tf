################################
# AMI: Ubuntu 24.04 LTS (Noble)
################################

data "aws_ami" "ubuntu_2404" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

################################
# IAM role + instance profile for SSM
################################

resource "aws_iam_role" "ec2_ssm" {
  name = "${var.name}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_core" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm" {
  name = "${var.name}-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm.name
}

################################
# Local placement helpers
################################

locals {
  subnet_a = var.subnet_ids[0]
  subnet_b = length(var.subnet_ids) > 1 ? var.subnet_ids[1] : var.subnet_ids[0]
}

################################
# Load Balancer instance
################################

resource "aws_instance" "lb" {
  ami           = data.aws_ami.ubuntu_2404.id
  instance_type = var.instance_type_lb
  key_name      = var.key_name

  subnet_id                   = local.subnet_a
  vpc_security_group_ids      = [var.sg_lb_id]
  associate_public_ip_address = var.associate_public_ip

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm.name

  tags = {
    Name = "${var.name}-lb"
    Role = "lb"
  }
}

################################
# Application instances
################################

resource "aws_instance" "app_1" {
  ami           = data.aws_ami.ubuntu_2404.id
  instance_type = var.instance_type_app
  key_name      = var.key_name

  subnet_id                   = local.subnet_a
  vpc_security_group_ids      = [var.sg_app_id]
  associate_public_ip_address = var.associate_public_ip

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm.name

  tags = {
    Name = "${var.name}-app-1"
    Role = "app"
  }
}

resource "aws_instance" "app_2" {
  ami           = data.aws_ami.ubuntu_2404.id
  instance_type = var.instance_type_app
  key_name      = var.key_name

  subnet_id                   = local.subnet_b
  vpc_security_group_ids      = [var.sg_app_id]
  associate_public_ip_address = var.associate_public_ip

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm.name

  tags = {
    Name = "${var.name}-app-2"
    Role = "app"
  }
}

################################
# Database instance
################################

resource "aws_instance" "db" {
  ami           = data.aws_ami.ubuntu_2404.id
  instance_type = var.instance_type_db
  key_name      = var.key_name

  subnet_id                   = local.subnet_b
  vpc_security_group_ids      = [var.sg_db_id]
  associate_public_ip_address = var.associate_public_ip

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm.name

  tags = {
    Name = "${var.name}-db"
    Role = "db"
  }
}
