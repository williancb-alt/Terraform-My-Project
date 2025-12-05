# Creates an ALB named "app-alb" deployed across my public subnets to distribute HTTP/HTTPS traffic to backend EC2 instances 
# or ASG with cross-AZ fault tolerance.
resource "aws_lb" "main" {
  name = "app-alb"
  load_balancer_type = "application"
  security_groups = [var.ec2_sg_id]  # ALB uses EC2 SG for inbound/outbound rules
  subnets = var.public_subnets
  enable_cross_zone_load_balancing = true
}

# Creates an ALB Target Group named "app-tg" that defines where Application Load Balancer routes HTTP traffic (port 80) 
# and how to monitor backend EC2 instance health
resource "aws_lb_target_group" "app" {
  name = "app-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

# Configures health check for the target group    
  health_check { 
    path = "/" 
    matcher = "200-299" 
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
    }
}

# Creates an HTTP listener on port 80 for ALB that forwards all incoming traffic to the "app-tg" target group 
# containing healthy EC2 instances.
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port = 80
  protocol = "HTTP"
  
  # Default rule sends all unmatched traffic to target group 
  default_action {
     type = "forward"
     target_group_arn = aws_lb_target_group.app.arn
    }
}

# Passes the ALB DNS name and target group ARN from this module to the root module and other modules, enabling access to web 
# application and ASG registration.
output "alb_dns_name" { value = aws_lb.main.dns_name } 
output "alb_dns_name" { value = aws_lb.main.dns_name }
output "target_group_arn" { value = aws_lb_target_group.app.arn }
