data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)
}

module "network" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  azs      = local.azs
}

module "compute" {
  source            = "./modules/ec2"
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  instance_type     = var.instance_type
  key_name          = var.key_name
}
