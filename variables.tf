variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI profile to use for authentication"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket to create"
  type        = string
}

variable "name" {
  description = "Project/environment name prefix"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (no-NAT dev setup: LB,app,DB,Consul live here)"
  type        = list(string)
}

variable "azs" {
  description = "Availability zones for public subnets (order must match public_subnet_cidrs)"
  type        = list(string)
}

variable "app_port" {
  description = "TCP port the Flask application listens on"
  type        = number
  default     = 5000
}

variable "enable_ssh" {
  description = "Whether to allow SSH access (prefer SSM; enable SSH only as a fallback)"
  type        = bool
  default     = false
}

variable "ssh_cidr_allowlist" {
  description = "CIDR allowlist for SSH when enable_ssh=true"
  type        = list(string)
  default     = []
}

variable "enable_consul_ui" {
  description = "Whether to allow access to Consul UI/API (8500) from consul_ui_cidr_allowlist"
  type        = bool
  default     = false
}

variable "consul_ui_cidr_allowlist" {
  description = "CIDR allowlist for Consul UI/API access (8500) if enabled"
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
}

variable "associate_public_ip" {
  description = "Whether to associate public IPs with instances (lab default true)"
  type        = bool
  default     = true
}

variable "instance_type_lb" {
  description = "EC2 instance type for the load balancer"
  type        = string
  default     = "t3.micro"
}

variable "instance_type_app" {
  description = "EC2 instance type for app instances"
  type        = string
  default     = "t3.micro"
}

variable "instance_type_db" {
  description = "EC2 instance type for db instance"
  type        = string
  default     = "t3.micro"
}

variable "enable_jenkins_ui" {
  description = "Whether to allow access to Jenkins UI (8080) from allowlist"
  type        = bool
}

variable "jenkins_ui_cidr_allowlist" {
  description = "CIDR allowlist for Jenkins UI access (8080)"
  type        = list(string)
}

variable "instance_type_consul" {
  description = "EC2 instance type for Consul instance"
  type        = string
  default     = "t3.micro"
}

variable "instance_type_jenkins" {
  description = "EC2 instance type for Jenkins instance"
  type        = string
  default     = "t3.micro"
}
