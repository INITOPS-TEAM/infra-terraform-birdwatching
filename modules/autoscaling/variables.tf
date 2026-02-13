variable "name" {
  description = "Project/environment name prefix"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ALB and ASG"
  type        = list(string)
}

variable "sg_alb_id" {
  description = "Security group ID for ALB"
  type        = string
}

variable "sg_app_id" {
  description = "Security group ID for application instances"
  type        = string
}

variable "app_port" {
  description = "TCP port the Flask application listens on"
  type        = number
  default     = 5000
}

variable "instance_type_app" {
  description = "EC2 instance type for application instances"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name for EC2 instances"
  type        = string
}

variable "asg_min_size" {
  description = "Minimum number of instances in Auto Scaling Group"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum number of instances in Auto Scaling Group"
  type        = number
  default     = 4
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in Auto Scaling Group"
  type        = number
  default     = 2
}
