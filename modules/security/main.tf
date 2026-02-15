### Security groups (no inline rules)

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
  description = "PostgreSQL security group (only from app SG)"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-sg-db"
  }
}

resource "aws_security_group" "consul" {
  name        = "${var.name}-sg-consul"
  description = "Consul server security group (internal access only; UI via allowlist)"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-sg-consul"
  }
}

resource "aws_security_group" "jenkins" {
  name        = "${var.name}-sg-jenkins"
  description = "Jenkins security group (UI via allowlist; deploy SSH to app)"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-sg-jenkins"
  }
}

### LB ingress (public web)

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

### LB to App (only app_port)

resource "aws_vpc_security_group_egress_rule" "lb_to_app" {
  description                  = "Forward traffic to app instances"
  security_group_id            = aws_security_group.lb.id
  ip_protocol                  = "tcp"
  from_port                    = var.app_port
  to_port                      = var.app_port
  referenced_security_group_id = aws_security_group.app.id
}

### App ingress (only from LB)

resource "aws_vpc_security_group_ingress_rule" "app_from_lb" {
  description                  = "App traffic from LB"
  security_group_id            = aws_security_group.app.id
  ip_protocol                  = "tcp"
  from_port                    = var.app_port
  to_port                      = var.app_port
  referenced_security_group_id = aws_security_group.lb.id
}

### DB ingress (only from App)

resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
  description                  = "PostgreSQL from app instances only"
  security_group_id            = aws_security_group.db.id
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
  referenced_security_group_id = aws_security_group.app.id
}

### SSH (optional fallback; prefer SSM)

resource "aws_vpc_security_group_ingress_rule" "ssh_to_lb" {
  for_each = var.enable_ssh ? toset(var.ssh_cidr_allowlist) : toset([])

  description       = "SSH to LB fallback prefer SSM"
  security_group_id = aws_security_group.lb.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = each.value
}

resource "aws_vpc_security_group_ingress_rule" "ssh_to_app" {
  for_each = var.enable_ssh ? toset(var.ssh_cidr_allowlist) : toset([])

  description       = "SSH to app instances fallback prefer SSM"
  security_group_id = aws_security_group.app.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = each.value
}

resource "aws_vpc_security_group_ingress_rule" "ssh_to_db" {
  for_each = var.enable_ssh ? toset(var.ssh_cidr_allowlist) : toset([])

  description       = "SSH to DB fallback prefer SSM"
  security_group_id = aws_security_group.db.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = each.value
}

resource "aws_vpc_security_group_ingress_rule" "ssh_to_consul" {
  for_each = var.enable_ssh ? toset(var.ssh_cidr_allowlist) : toset([])

  description       = "SSH to Consul fallback prefer SSM"
  security_group_id = aws_security_group.consul.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = each.value
}

resource "aws_vpc_security_group_ingress_rule" "ssh_to_jenkins" {
  for_each = var.enable_ssh ? toset(var.ssh_cidr_allowlist) : toset([])

  description       = "SSH to Jenkins fallback prefer SSM"
  security_group_id = aws_security_group.jenkins.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = each.value
}

### App SSH from Jenkins (deploy)

resource "aws_vpc_security_group_ingress_rule" "ssh_to_app_from_jenkins" {
  description                  = "SSH deploy access from Jenkins"
  security_group_id            = aws_security_group.app.id
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
  referenced_security_group_id = aws_security_group.jenkins.id
}

### SSH between instances (ALL to ALL)

locals {
  ssh_sg_ids = {
    lb      = aws_security_group.lb.id
    app     = aws_security_group.app.id
    db      = aws_security_group.db.id
    consul  = aws_security_group.consul.id
    jenkins = aws_security_group.jenkins.id
  }
}

# Ingress 22 to LB from all SGs
resource "aws_vpc_security_group_ingress_rule" "ssh_lb_from_sgs" {
  for_each = local.ssh_sg_ids

  description                  = "SSH to LB from ${each.key}"
  security_group_id            = aws_security_group.lb.id
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
  referenced_security_group_id = each.value
}

# Ingress 22 to App from all SGs
resource "aws_vpc_security_group_ingress_rule" "ssh_app_from_sgs" {
  for_each = local.ssh_sg_ids

  description                  = "SSH to App from ${each.key}"
  security_group_id            = aws_security_group.app.id
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
  referenced_security_group_id = each.value
}

# Ingress 22 to DB from all SGs
resource "aws_vpc_security_group_ingress_rule" "ssh_db_from_sgs" {
  for_each = local.ssh_sg_ids

  description                  = "SSH to DB from ${each.key}"
  security_group_id            = aws_security_group.db.id
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
  referenced_security_group_id = each.value
}

# Ingress 22 to Consul from all SGs
resource "aws_vpc_security_group_ingress_rule" "ssh_consul_from_sgs" {
  for_each = local.ssh_sg_ids

  description                  = "SSH to Consul from ${each.key}"
  security_group_id            = aws_security_group.consul.id
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
  referenced_security_group_id = each.value
}

# Ingress 22 to Jenkins from all SGs
resource "aws_vpc_security_group_ingress_rule" "ssh_jenkins_from_sgs" {
  for_each = local.ssh_sg_ids

  description                  = "SSH to Jenkins from ${each.key}"
  security_group_id            = aws_security_group.jenkins.id
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
  referenced_security_group_id = each.value
}

### Egress to Consul
# Instances talk to Consul via private IP but SG-to-SG works regardless

resource "aws_vpc_security_group_egress_rule" "app_to_consul_8500" {
  description                  = "App to Consul HTTP API 8500 tcp"
  security_group_id            = aws_security_group.app.id
  ip_protocol                  = "tcp"
  from_port                    = 8500
  to_port                      = 8500
  referenced_security_group_id = aws_security_group.consul.id
}

resource "aws_vpc_security_group_egress_rule" "app_to_consul_8600_tcp" {
  description                  = "App to Consul DNS 8600 tcp"
  security_group_id            = aws_security_group.app.id
  ip_protocol                  = "tcp"
  from_port                    = 8600
  to_port                      = 8600
  referenced_security_group_id = aws_security_group.consul.id
}

resource "aws_vpc_security_group_egress_rule" "app_to_consul_8600_udp" {
  description                  = "App to Consul DNS 8600 udp"
  security_group_id            = aws_security_group.app.id
  ip_protocol                  = "udp"
  from_port                    = 8600
  to_port                      = 8600
  referenced_security_group_id = aws_security_group.consul.id
}

resource "aws_vpc_security_group_egress_rule" "lb_to_consul_8500" {
  description                  = "LB to Consul HTTP API 8500 tcp"
  security_group_id            = aws_security_group.lb.id
  ip_protocol                  = "tcp"
  from_port                    = 8500
  to_port                      = 8500
  referenced_security_group_id = aws_security_group.consul.id
}

resource "aws_vpc_security_group_egress_rule" "lb_to_consul_8600_tcp" {
  description                  = "LB to Consul DNS 8600 tcp"
  security_group_id            = aws_security_group.lb.id
  ip_protocol                  = "tcp"
  from_port                    = 8600
  to_port                      = 8600
  referenced_security_group_id = aws_security_group.consul.id
}

resource "aws_vpc_security_group_egress_rule" "lb_to_consul_8600_udp" {
  description                  = "LB to Consul DNS 8600 udp"
  security_group_id            = aws_security_group.lb.id
  ip_protocol                  = "udp"
  from_port                    = 8600
  to_port                      = 8600
  referenced_security_group_id = aws_security_group.consul.id
}

resource "aws_vpc_security_group_egress_rule" "db_to_consul_8500" {
  description                  = "DB to Consul HTTP API 8500 tcp"
  security_group_id            = aws_security_group.db.id
  ip_protocol                  = "tcp"
  from_port                    = 8500
  to_port                      = 8500
  referenced_security_group_id = aws_security_group.consul.id
}

resource "aws_vpc_security_group_egress_rule" "db_to_consul_8600_tcp" {
  description                  = "DB to Consul DNS 8600 tcp"
  security_group_id            = aws_security_group.db.id
  ip_protocol                  = "tcp"
  from_port                    = 8600
  to_port                      = 8600
  referenced_security_group_id = aws_security_group.consul.id
}

resource "aws_vpc_security_group_egress_rule" "db_to_consul_8600_udp" {
  description                  = "DB to Consul DNS 8600 udp"
  security_group_id            = aws_security_group.db.id
  ip_protocol                  = "udp"
  from_port                    = 8600
  to_port                      = 8600
  referenced_security_group_id = aws_security_group.consul.id
}

### Consul inbound (internal only)

# 8300-8302: internal (from app)
resource "aws_vpc_security_group_ingress_rule" "consul_8300_from_app" {
  description                  = "Consul RPC 8300 tcp from app"
  security_group_id            = aws_security_group.consul.id
  ip_protocol                  = "tcp"
  from_port                    = 8300
  to_port                      = 8300
  referenced_security_group_id = aws_security_group.app.id
}

resource "aws_vpc_security_group_ingress_rule" "consul_8301_tcp_from_app" {
  description                  = "Consul gossip LAN 8301 tcp from app"
  security_group_id            = aws_security_group.consul.id
  ip_protocol                  = "tcp"
  from_port                    = 8301
  to_port                      = 8301
  referenced_security_group_id = aws_security_group.app.id
}

resource "aws_vpc_security_group_ingress_rule" "consul_8301_udp_from_app" {
  description                  = "Consul gossip LAN 8301 udp from app"
  security_group_id            = aws_security_group.consul.id
  ip_protocol                  = "udp"
  from_port                    = 8301
  to_port                      = 8301
  referenced_security_group_id = aws_security_group.app.id
}

# 8600: DNS from app (tcp/udp)
resource "aws_vpc_security_group_ingress_rule" "consul_8600_tcp_from_app" {
  description                  = "Consul DNS 8600 tcp from app"
  security_group_id            = aws_security_group.consul.id
  ip_protocol                  = "tcp"
  from_port                    = 8600
  to_port                      = 8600
  referenced_security_group_id = aws_security_group.app.id
}

resource "aws_vpc_security_group_ingress_rule" "consul_8600_udp_from_app" {
  description                  = "Consul DNS 8600 udp from app"
  security_group_id            = aws_security_group.consul.id
  ip_protocol                  = "udp"
  from_port                    = 8600
  to_port                      = 8600
  referenced_security_group_id = aws_security_group.app.id
}

# 8500: UI/API from allowlist only (optional)
resource "aws_vpc_security_group_ingress_rule" "consul_8500_ui" {
  for_each = var.enable_consul_ui ? toset(var.consul_ui_cidr_allowlist) : toset([])

  description       = "Consul UI 8500 tcp from allowlist"
  security_group_id = aws_security_group.consul.id
  ip_protocol       = "tcp"
  from_port         = 8500
  to_port           = 8500
  cidr_ipv4         = each.value
}

### Jenkins inbound (UI)

resource "aws_vpc_security_group_ingress_rule" "jenkins_8080_ui" {
  for_each = var.enable_jenkins_ui ? toset(var.jenkins_ui_cidr_allowlist) : toset([])

  description       = "Jenkins UI 8080 tcp from allowlist"
  security_group_id = aws_security_group.jenkins.id
  ip_protocol       = "tcp"
  from_port         = 8080
  to_port           = 8080
  cidr_ipv4         = each.value
}

### General outbound

resource "aws_vpc_security_group_egress_rule" "app_all_out" {
  description       = "App outbound to internet for updates"
  security_group_id = aws_security_group.app.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "db_all_out" {
  description       = "DB outbound to internet for updates"
  security_group_id = aws_security_group.db.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "consul_all_out" {
  description       = "Consul outbound to internet for updates"
  security_group_id = aws_security_group.consul.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "lb_all_out" {
  description       = "LB outbound to internet for updates"
  security_group_id = aws_security_group.lb.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "jenkins_all_out" {
  description       = "Jenkins outbound to internet for updates and plugins"
  security_group_id = aws_security_group.jenkins.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
