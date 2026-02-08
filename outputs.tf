output "bucket_name" {
  description = "Name of the S3 bucket used by Terraform infrastructure"
  value       = module.s3.bucket_name
}

output "bucket_arn" {
  description = "ARN of the S3 bucket used by Terraform infrastructure"
  value       = module.s3.bucket_arn
}

output "vpc_id" {
  description = "ID of the VPC created for the pictapp environment"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of public subnets used for LB,app,DB and Consul (no-NAT dev setup)"
  value       = module.network.public_subnet_ids
}

output "sg_lb_id" {
  description = "Security group ID for the LB"
  value       = module.security.sg_lb_id
}

output "sg_app_id" {
  description = "Security group ID for application instances"
  value       = module.security.sg_app_id
}

output "sg_db_id" {
  description = "Security group ID for the PostgreSQL instance"
  value       = module.security.sg_db_id
}

output "sg_consul_id" {
  description = "Security group ID for the Consul server"
  value       = module.security.sg_consul_id
}
