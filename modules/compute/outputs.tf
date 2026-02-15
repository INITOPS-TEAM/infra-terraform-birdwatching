output "consul_public_ip" {
  description = "Public IP of the Consul instance (lab setup)"
  value       = aws_instance.consul.public_ip
}

output "jenkins_public_ip" {
  description = "Public IP of the Jenkins instance"
  value       = aws_instance.jenkins.public_ip
}
