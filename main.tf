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

  name   = var.name
  vpc_id = module.network.vpc_id

  app_port = var.app_port
}
