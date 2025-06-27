provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket  = "mongodb-infra"
    key     = "mongodb-terraform/terraform.tfstate"
    region  = "us-west-2"
    encrypt = true
  }
}

module "vpc" {
  source   = "./modules/networking/vpc"
  vpc_cidr = var.vpc_cidr
}

module "subnets" {
  source                = "./modules/networking/subnets"
  vpc_id                = module.vpc.vpc_id
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  availability_zones    = var.availability_zones
}

module "internet_gateway" {
  source = "./modules/networking/internet-gateway"
  vpc_id = module.vpc.vpc_id
}

module "route_table" {
  source            = "./modules/networking/route-table"
  vpc_id            = module.vpc.vpc_id
  igw_id            = module.internet_gateway.igw_id
  public_subnet_ids = module.subnets.public_subnet_ids
}

module "nat_gateway" {
  source             = "./modules/networking/nat-gateway"
  public_subnet_id   = module.subnets.public_subnet_ids[0]
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.subnets.private_subnet_ids
}

module "security_groups" {
  source = "./modules/networking/security-groups"
  vpc_id = module.vpc.vpc_id
}

module "bastion_host" {
  source           = "./modules/bastion-host"
  public_subnet_id = module.subnets.public_subnet_ids[0]
  bastion_sg_id    = module.security_groups.bastion_sg_id
  key_name         = var.key_name
}

module "mongodb_servers" {
  source             = "./modules/mongodb-servers"
  private_subnet_ids = module.subnets.private_subnet_ids
  mongodb_sg_id      = module.security_groups.mongodb_sg_id
  key_name           = var.key_name
}
