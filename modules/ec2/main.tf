
# It creates an Auto Scaling Group (ASG) that launches dynamic, identical EC2 instances
# Instances are ephemeral (terminated/scaled automatically)
# AWS will auto-generates names like i-0abcdef1234567890

# This block queries the latest Amazon Linux 2023 AMI ID matching the specified criteria, avoiding hardcoded AMI IDs that change overtime
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter { 
    name = "name"
    values = ["al2023-ami-*-x86_64"] 
  }
}

# Creates Launch Template called "app-lt" for EC2 instances in the ASG. Serves as a reusable blueprint for launching EC2 instancs.
resource "aws_launch_template" "app" {
  name = "app-lt"
  image_id = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [var.ec2_sg_id]
  user_data = base64encode(templatefile("${path.module}/user_data.sh", { target_group_arn = var.target_group_arn }))
}

# Creates ASG called "app" to automatically manage EC2 instances, in this case launching 2 instances across private 
# subnets scalling up to 4 max or down to 2 min as needed. ASG integrates with the ALB target group to distribute traffic and perform health checks
resource "aws_autoscaling_group" "app" {
  desired_capacity = 2
  max_size = 4
  min_size = 2
  vpc_zone_identifier = var.private_subnets
  target_group_arns = [var.target_group_arn]
  launch_template { 
    id = aws_launch_template.app.id
    version = "$Latest" 
  }
}
