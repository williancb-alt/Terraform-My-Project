# Delete these:
# module "vpc" { source = "./modules/vpc" }
# module "alb" { ... }

# Add resources directly:
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}


<img width="2785" height="1040" alt="Overview" src="https://github.com/user-attachments/assets/d7abca40-3d9c-4ee1-a315-5bf60995d398" />
