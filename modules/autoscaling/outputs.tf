output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.app.dns_name
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.app.arn
}

output "alb_zone_id" {
  description = "Zone ID of the ALB"
  value       = aws_lb.app.zone_id
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.app.arn
}

output "asg_name" {
  description = "Name of the ASG"
  value       = aws_autoscaling_group.app.name
}

output "asg_arn" {
  description = "ARN of the ASG"
  value       = aws_autoscaling_group.app.arn
}
