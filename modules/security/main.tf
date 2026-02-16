### Shared internal Security Group

resource "aws_security_group" "internal" {
  name        = "${var.name}-sg-internal"
  description = "Shared internal SG for traffic in cluster"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-sg-internal"
  }
}

### Consul inbound (internal only)

resource "aws_vpc_security_group_ingress_rule" "consul_8300_from_internal" {
  description                  = "Consul RPC 8300 tcp from internal SG"
  security_group_id            = aws_security_group.internal.id
  ip_protocol                  = "tcp"
  from_port                    = 8300
  to_port                      = 8301
  referenced_security_group_id = aws_security_group.internal.id
}

resource "aws_vpc_security_group_ingress_rule" "consul_8301_tcp_from_internal" {
  description                  = "Consul gossip LAN 8301 tcp from internal SG"
  security_group_id            = aws_security_group.internal.id
  ip_protocol                  = "tcp"
  from_port                    = 8301
  to_port                      = 8301
  referenced_security_group_id = aws_security_group.internal.id
}

resource "aws_vpc_security_group_ingress_rule" "consul_8301_udp_from_internal" {
  description                  = "Consul gossip LAN 8301 udp from internal SG"
  security_group_id            = aws_security_group.internal.id
  ip_protocol                  = "udp"
  from_port                    = 8301
  to_port                      = 8301
  referenced_security_group_id = aws_security_group.internal.id
}

# 8600: DNS from app (tcp/udp)
resource "aws_vpc_security_group_ingress_rule" "consul_8600_tcp_from_internal" {
  description                  = "Consul DNS 8600 tcp from internal SG"
  security_group_id            = aws_security_group.internal.id
  ip_protocol                  = "tcp"
  from_port                    = 8600
  to_port                      = 8600
  referenced_security_group_id = aws_security_group.internal.id
}

resource "aws_vpc_security_group_ingress_rule" "consul_8600_udp_from_internal" {
  description                  = "Consul DNS 8600 udp from internal SG"
  security_group_id            = aws_security_group.internal.id
  ip_protocol                  = "udp"
  from_port                    = 8600
  to_port                      = 8600
  referenced_security_group_id = aws_security_group.internal.id
}

### Jenkins UI

resource "aws_vpc_security_group_ingress_rule" "jenkins_8080" {

  description       = "Jenkins UI 8080 tcp from allowlist"
  security_group_id = aws_security_group.jenkins.id
  ip_protocol       = "tcp"
  from_port         = 8080
  to_port           = 8080
  cidr_ipv4         = "0.0.0.0/0"
}

# SSH (temporary; prefer SSM)
resource "aws_vpc_security_group_ingress_rule" "ssh_from_allowlist" {

  description       = "SSH 22 from allowlist"
  security_group_id = aws_security_group.internal.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  referenced_security_group_id = aws_security_group.jenkins.id
}

# Common outbound for all instances
resource "aws_vpc_security_group_egress_rule" "internal_all_out" {
  description       = "Outbound to anywhere"
  security_group_id = aws_security_group.internal.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

### Role Security Groups

resource "aws_security_group" "lb" {
  name        = "${var.name}-sg-lb"
  description = "Load balancer security group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-sg-lb"
  }
}

resource "aws_security_group" "app" {
  name        = "${var.name}-sg-app"
  description = "Application instances security group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-sg-app"
  }
}

resource "aws_security_group" "db" {
  name        = "${var.name}-sg-db"
  description = "PostgreSQL security group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-sg-db"
  }
}

resource "aws_security_group" "consul" {
  name        = "${var.name}-sg-consul"
  description = "Consul server security group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-sg-consul"
  }
}


resource "aws_security_group" "jenkins" {
  name        = "${var.name}-sg-jenkins"
  description = "Jenkins security group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-sg-jenkins"
  }
}


### LB public ingress

resource "aws_vpc_security_group_ingress_rule" "lb_http" {
  description       = "HTTP from internet"
  security_group_id = aws_security_group.lb.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "lb_https" {
  description       = "HTTPS from internet"
  security_group_id = aws_security_group.lb.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}

### App ingress from LB

resource "aws_vpc_security_group_ingress_rule" "app_from_lb" {
  description                  = "App traffic from LB on app_port"
  security_group_id            = aws_security_group.app.id
  ip_protocol                  = "tcp"
  from_port                    = var.app_port
  to_port                      = var.app_port
  referenced_security_group_id = aws_security_group.lb.id
}

### DB ingress from App

resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
  description                  = "PostgreSQL from app SG"
  security_group_id            = aws_security_group.db.id
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
  referenced_security_group_id = aws_security_group.app.id
}

### Consul UI

# resource "aws_vpc_security_group_ingress_rule" "consul_ui_8501" {
#   for_each = var.enable_consul_ui ? toset(var.consul_ui_cidr_allowlist) : toset([])

#   description       = "Consul UI/API 8501 from allowlist"
#   security_group_id = aws_security_group.consul.id
#   ip_protocol       = "tcp"
#   from_port         = 8501
#   to_port           = 8501
#   cidr_ipv4         = each.value
# }


