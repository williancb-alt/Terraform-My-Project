# Define customizable input parameters with defaults allowing the configuration to be reusable across environments or regions 
# without code changes

# Defaults work automatically: terraform apply uses us-east-1 + 2 AZs.
variable "aws_region" { default = "us-east-1" }
variable "availability_zones" {
    type = list(string) 
    default = ["us-east-1a", "us-east-1b"] 
}
