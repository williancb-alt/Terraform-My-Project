# Creates a Security Group named "alb-sg" for an Application Load Balancer (ALB) within a specified VPC
resource "aws_security_group" "alb" {
  vpc_id = var.vpc_id

  # Allows inbound TCP traffic on port 80 (HTTP) from any IP address worldwide (0.0.0.0/0), enabling public access to the ALB.
  ingress { 
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # Permits all outbound traffic (from_port = 0, to_port = 0, protocol = "-1") to any destination (0.0.0.0/0), 
  # which is standard for load balancers to forward traffic to backend targets.
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  tags = { Name = "alb-sg" }
}

# Creates a Security Group named "ec2-sg" for EC2 instances within a specified VPC.
resource "aws_security_group" "ec2" {
  vpc_id = var.vpc_id

  # Allows inbound TCP traffic on port 80 (HTTP) only from the ALB security group 
  # (aws_security_group.alb.id), restricting access to traffic forwarded by the load balancer for security.
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.alb.id] 
  }

  # Permits all outbound traffic (from_port = 0, to_port = 0, protocol = "-1") to any destination (0.0.0.0/0),
  # enabling EC2 instances to reach external services or the internet.
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  tags = { Name = "ec2-sg" }
}

# Defines two output values that expose the IDs of the created security groups after the deployment

# Returns the ID of the ALB security group, accessible via terraform output alb_sg_id
output "alb_sg_id" { value = aws_security_group.alb.id }

# Returns the ID of the EC2 security group, similarly queryable post-apply.
output "ec2_sg_id" { value = aws_security_group.ec2.id }
