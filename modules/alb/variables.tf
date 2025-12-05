# Defines three input variables to parameterize the configuration, enabling reuse across environments or modules.
#Accepts a string value for the AWS VPC ID where resources will be created
variable "vpc_id" {}

#Expects a list of strings containing public subnet IDs
variable "public_subnets" { type = list(string) }

# Takes a string value for an existing EC2 security group ID, typically passed from another module's output
variable "ec2_sg_id" {}
