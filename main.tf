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