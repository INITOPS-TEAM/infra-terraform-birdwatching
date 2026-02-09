output "sg_lb_id" {
  description = "Security group ID for the load balancer"
  value       = aws_security_group.lb.id
}

output "sg_app_id" {
  description = "Security group ID for application instances"
  value       = aws_security_group.app.id
}

output "sg_db_id" {
  description = "Security group ID for PostgreSQL"
  value       = aws_security_group.db.id
}

output "sg_consul_id" {
  description = "Security group ID for Consul server"
  value       = aws_security_group.consul.id
}
