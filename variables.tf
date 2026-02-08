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
  description = "Whether to allow SSH access to instances (prefer SSM if possible)"
  type        = bool
  default     = false
}

variable "ssh_cidr_allowlist" {
  description = "CIDR allowlist for SSH when enable_ssh=true (never use 0.0.0.0/0)"
  type        = list(string)
  default     = []
}

variable "enable_consul_ui_public_access" {
  description = "Whether to allow access to Consul UI/API on port 8500 from consul_ui_cidr_allowlist"
  type        = bool
  default     = false
}

variable "consul_ui_cidr_allowlist" {
  description = "CIDR allowlist for Consul UI/API access (8500) when enable_consul_ui_public_access=true"
  type        = list(string)
  default     = []
}
