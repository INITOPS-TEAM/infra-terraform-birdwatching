variable "name" {
  description = "Project/environment name prefix"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for instances placement"
  type        = list(string)
}

variable "key_name" {
  description = "EC2 key pair name for SSH access (must exist in AWS)"
  type        = string
}

variable "associate_public_ip" {
  description = "Whether to associate public IPs (required for SSM without NAT/VPC endpoints in this lab setup)"
  type        = bool
  default     = true
}

variable "instance_type_lb" {
  description = "EC2 instance type for the load balancer VM"
  type        = string
  default     = "t3.micro"
}

variable "instance_type_app" {
  description = "EC2 instance type for application VMs"
  type        = string
  default     = "t3.micro"
}

variable "instance_type_db" {
  description = "EC2 instance type for the database VM"
  type        = string
  default     = "t3.micro"
}

variable "sg_lb_id" {
  description = "Security group ID for the load balancer instance"
  type        = string
}

variable "sg_app_id" {
  description = "Security group ID for the application instances"
  type        = string
}

variable "sg_db_id" {
  description = "Security group ID for the database instance"
  type        = string
}
