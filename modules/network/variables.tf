variable "name" {
  description = "Project/environment name prefix"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets (instances here have outbound internet via IGW)"
  type        = list(string)
}

variable "azs" {
  description = "List of availability zones to spread subnets across (order must match public_subnet_cidrs)"
  type        = list(string)
}
