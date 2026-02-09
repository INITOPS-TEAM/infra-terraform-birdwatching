module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}

module "network" {
  source = "./modules/network"

  name                = var.name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  azs                 = var.azs
}

module "security" {
  source = "./modules/security"

  name     = var.name
  vpc_id   = module.network.vpc_id
  app_port = var.app_port

  enable_ssh         = var.enable_ssh
  ssh_cidr_allowlist = var.ssh_cidr_allowlist

  enable_consul_ui         = var.enable_consul_ui
  consul_ui_cidr_allowlist = var.consul_ui_cidr_allowlist
}

module "compute" {
  source = "./modules/compute"

  name                = var.name
  subnet_ids          = module.network.public_subnet_ids
  key_name            = var.key_name
  associate_public_ip = var.associate_public_ip

  instance_type_lb  = var.instance_type_lb
  instance_type_app = var.instance_type_app
  instance_type_db  = var.instance_type_db

  sg_lb_id  = module.security.sg_lb_id
  sg_app_id = module.security.sg_app_id
  sg_db_id  = module.security.sg_db_id
}
