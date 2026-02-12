### AMI: Ubuntu 24.04 LTS

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

### IAM role + instance profile for SSM

resource "aws_iam_role" "ec2_ssm" {
  name = "${var.name}-${local.iam_suffix}-ec2-ssm-role"

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
  name = "${var.name}-${local.iam_suffix}-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm.name
}

### IAM role + instance profile for Jenkins

resource "aws_iam_role" "jenkins" {
  name = "${var.name}-${local.iam_suffix}-jenkins-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_ssm_core" {
  role       = aws_iam_role.jenkins.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "jenkins_s3" {
  name = "${var.name}-${local.iam_suffix}-jenkins-s3"
  role = aws_iam_role.jenkins.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = ["arn:aws:s3:::${var.s3_bucket_name}"]
      },
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Resource = ["arn:aws:s3:::${var.s3_bucket_name}/*"]
      }
    ]
  })
}

resource "aws_iam_instance_profile" "jenkins" {
  name = "${var.name}-${local.iam_suffix}-jenkins-profile"
  role = aws_iam_role.jenkins.name
}

### Local placement helpers

locals {
  subnet_a = var.subnet_ids[0]
  subnet_b = length(var.subnet_ids) > 1 ? var.subnet_ids[1] : var.subnet_ids[0]

  iam_suffix = "${var.env}-${var.aws_region}"
}

### Load Balancer instance

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

### Application instances

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

### Database instance

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

### Consul instance

resource "aws_instance" "consul" {
  ami           = data.aws_ami.ubuntu_2404.id
  instance_type = var.instance_type_consul
  key_name      = var.key_name

  subnet_id                   = local.subnet_b
  vpc_security_group_ids      = [var.sg_consul_id]
  associate_public_ip_address = var.associate_public_ip

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm.name

  tags = {
    Name = "${var.name}-consul"
    Role = "consul"
  }
}

# Jenkins instance

resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.ubuntu_2404.id
  instance_type = var.instance_type_jenkins
  key_name      = var.key_name

  subnet_id                   = local.subnet_a
  vpc_security_group_ids      = [var.sg_jenkins_id]
  associate_public_ip_address = var.associate_public_ip

  user_data = file("${path.module}/user_data/jenkins.sh")

  iam_instance_profile = aws_iam_instance_profile.jenkins.name

  tags = {
    Name = "${var.name}-jenkins"
    Role = "jenkins"
  }
}
