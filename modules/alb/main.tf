resource "aws_lb" "main" {
  name = "app-alb"
  load_balancer_type = "application"
  security_groups = [var.ec2_sg_id]  # ALB uses EC2 SG for simplicity
  subnets = var.public_subnets
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_target_group" "app" {
  name = "app-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  
  health_check { 
    path = "/" 
    matcher = "200-299" 
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
    }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port = 80
  protocol = "HTTP"
  
  default_action {
     type = "forward"
     target_group_arn = aws_lb_target_group.app.arn
    }
}

output "alb_dns_name" { value = aws_lb.main.dns_name }
output "target_group_arn" { value = aws_lb_target_group.app.arn }
