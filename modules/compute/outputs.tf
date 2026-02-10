output "lb_public_ip" {
  description = "Public IP of the load balancer instance"
  value       = aws_instance.lb.public_ip
}

output "lb_private_ip" {
  description = "Private IP of the load balancer instance"
  value       = aws_instance.lb.private_ip
}

output "app_private_ips" {
  description = "Private IPs of app instances"
  value       = [aws_instance.app_1.private_ip, aws_instance.app_2.private_ip]
}

output "app_public_ips" {
  description = "Public IPs of app instances (lab setup)"
  value       = [aws_instance.app_1.public_ip, aws_instance.app_2.public_ip]
}

output "db_private_ip" {
  description = "Private IP of the database instance"
  value       = aws_instance.db.private_ip
}

output "db_public_ip" {
  description = "Public IP of the database instance (lab setup)"
  value       = aws_instance.db.public_ip
}

output "consul_private_ip" {
  description = "Private IP of the Consul instance"
  value       = aws_instance.consul.private_ip
}

output "consul_public_ip" {
  description = "Public IP of the Consul instance (lab setup)"
  value       = aws_instance.consul.public_ip
}

output "jenkins_public_ip" {
  description = "Public IP of the Jenkins instance"
  value       = aws_instance.jenkins.public_ip
}

output "jenkins_private_ip" {
  description = "Private IP of the Jenkins instance"
  value       = aws_instance.jenkins.private_ip
}
