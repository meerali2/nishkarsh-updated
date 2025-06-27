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

module "networking" {
  source               = "./networking"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "bastion_host" {
  source           = "./bastion-host"
  public_subnet_id = module.networking.public_subnet_ids[0]
  bastion_sg_id    = module.networking.bastion_sg_id
  key_name         = var.key_name
}

module "mongodb_servers" {
  source             = "./mongodb-servers"
  private_subnet_ids = module.networking.private_subnet_ids
  mongodb_sg_id      = module.networking.mongodb_sg_id
  key_name           = var.key_name
}
