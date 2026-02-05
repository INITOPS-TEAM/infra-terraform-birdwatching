variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "eu-central-1"
}

variable "aws_profile" {
  description = "AWS CLI profile to use for authentication"
  type        = string
  default     = "iac"
}

variable "bucket_name" {
  description = "Name of the S3 bucket to create"
  type        = string
}
