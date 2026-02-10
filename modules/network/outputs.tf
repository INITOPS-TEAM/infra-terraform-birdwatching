output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs (used by LB,app,DB,Consul in the no-NAT dev setup)"
  value       = [for s in aws_subnet.public : s.id]
}
