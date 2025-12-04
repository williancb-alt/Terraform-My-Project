<<<<<<< HEAD
terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" { region = var.aws_region }

module "vpc" { 
  source = "./modules/vpc" 
  availability_zones = var.availability_zones
}
module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id 
}
module "alb" { 
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  ec2_sg_id = module.security.ec2_sg_id
}
module "ec2" { 
  source = "./modules/ec2"
  private_subnets = module.vpc.private_subnets
  ec2_sg_id = module.security.ec2_sg_id
  target_group_arn = module.alb.target_group_arn
}
=======
terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" { region = var.aws_region }

module "vpc" { 
  source = "./modules/vpc" 
  availability_zones = var.availability_zones
}
module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id 
}
module "alb" { 
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  ec2_sg_id = module.security.ec2_sg_id
}
module "ec2" { 
  source = "./modules/ec2"
  private_subnets = module.vpc.private_subnets
  ec2_sg_id = module.security.ec2_sg_id
  target_group_arn = module.alb.target_group_arn
}
>>>>>>> 8dc6019a7ecc5a45fd129da005b0ac71525e314b
