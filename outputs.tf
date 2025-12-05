# These output expose the ALB DNS name and target group ARN from the alb child module, 
# making them accessible via terraform output CLI commands and usable by external systems.
output "alb_dns" { value = module.alb.alb_dns_name }
output "target_group_arn" { value = module.alb.target_group_arn }
