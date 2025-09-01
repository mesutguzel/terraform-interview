
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
}
locals {
  public_subnet_cidrs = [for i in range(length(var.azs)) : cidrsubnet(var.vpc_cidr, 8, i)]
  private_subnet_cidrs = [for i in range(length(var.azs)) : cidrsubnet(var.vpc_cidr, 8, i + 16)]
  public_subnets = { for idx, az in var.azs : az => local.public_subnet_cidrs[idx] }
  private_subnets = { for idx, az in var.azs : az => local.private_subnet_cidrs[idx] }
}
resource "aws_subnet" "public" {
  for_each = local.public_subnets
  vpc_id = aws_vpc.this.id
  cidr_block = each.value
  availability_zone = each.key
  map_public_ip_on_launch = true
}
resource "aws_subnet" "private" {
  for_each = local.private_subnets
  vpc_id = aws_vpc.this.id
  cidr_block = each.value
  availability_zone = each.key
  map_public_ip_on_launch = false
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route" "public_internet_access" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public
  subnet_id = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private
  subnet_id = each.value.id
  route_table_id = aws_route_table.private.id
}
