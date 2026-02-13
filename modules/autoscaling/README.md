# Autoscaling module

## Purpose
Manages auto-scaling infrastructure for Flask application instances using AWS Auto Scaling Group and Application Load Balancer.

## Resources
- `aws_lb` - Application Load Balancer
- `aws_lb_target_group` - Target group for Flask apps
- `aws_lb_listener` - HTTP listener on port 80
- `aws_launch_template` - Launch template for app instances
- `aws_autoscaling_group` - Auto Scaling Group (min=2, max=4)
- `aws_cloudwatch_metric_alarm` - CPU monitoring alarms
- `aws_autoscaling_policy` - Scale up/down policies

## Inputs
- `name` - Project/environment name prefix
- `vpc_id` - VPC ID
- `subnet_ids` - List of subnet IDs for ALB and ASG
- `sg_alb_id` - Security group ID for ALB
- `sg_app_id` - Security group ID for app instances
- `app_port` - Flask application port (default: 5000)
- `instance_type_app` - EC2 instance type (default: t3.micro)
- `key_name` - EC2 key pair name
- `iam_instance_profile_name` - IAM instance profile for SSM
- `asg_min_size` - Minimum instances (default: 2)
- `asg_max_size` - Maximum instances (default: 4)
- `asg_desired_capacity` - Desired instances (default: 2)

## Outputs
- `alb_dns_name` - ALB DNS name (use for DNS configuration)
- `alb_arn` - ALB ARN
- `alb_zone_id` - ALB Zone ID (for Route53)
- `target_group_arn` - Target group ARN
- `asg_name` - Auto Scaling Group name
- `asg_arn` - Auto Scaling Group ARN

## Notes
- Health checks on `/` endpoint every 30 seconds
- Scale up when CPU > 70% for 10 minutes
- Scale down when CPU < 30% for 10 minutes
- Cooldown period: 5 minutes
- App deployment handled by Jenkins/Ansible
- Instances tagged with `Role=app` for Jenkins discovery
