data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter { 
    name = "name"
    values = ["al2023-ami-*-x86_64"] 
  }
}

resource "aws_launch_template" "app" {
  name = "app-lt"
  image_id = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [var.ec2_sg_id]
  user_data = base64encode(templatefile("${path.module}/user_data.sh", { target_group_arn = var.target_group_arn }))
}

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
