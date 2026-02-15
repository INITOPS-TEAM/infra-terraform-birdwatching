output "vpc_id" {
  description = "ID of the VPC created for the pictapp environment"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of public subnets used for LB,app,DB and Consul (no-NAT dev setup)"
  value       = module.network.public_subnet_ids
}

output "consul_public_ip" {
  description = "Public ID of Consul"
  value       = module.compute.consul_public_ip
}

output "jenkins_public_ip" {
  description = "Public IP of Jenkins"
  value       = module.compute.jenkins_public_ip
}
