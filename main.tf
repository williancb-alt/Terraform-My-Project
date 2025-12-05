# Declares the required AWS provider from HashiCorp's registry and constrains it to version ~> 5.0
terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

# Configures to deploy all resources (VPC, EC2, ALB, etc.) in the region specified by var.aws_region
provider "aws" { region = var.aws_region }

# Calls local VPC module from ./modules/vpc/, passing availability_zones variable to create a VPC infrastructure such as 
# VPC, public/private subnets, NAT, route tables, IGW, etc.
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

# Declares provider requirements for the configuration.
# Sets up the AWS provider and orchestrates four modules to create a complete AWS web infrastructure stack.
terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" { region = var.aws_region }

# Creates VPC infrastructure and outputs vpc_id, public_subnets, and private_subnets.
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
