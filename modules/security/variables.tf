variable "name" {
  description = "Project/environment name prefix"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "app_port" {
  description = "TCP port the application listens on"
  type        = number
  default     = 5000
}

variable "enable_ssh" {
  description = "Whether to allow SSH access (prefer SSM Session Manager; enable SSH only as a temporary fallback)"
  type        = bool
  default     = false
}

variable "ssh_cidr_allowlist" {
  description = "CIDR allowlist for SSH (avoid 0.0.0.0/0; GitHub-hosted runners have unstable IPs)"
  type        = list(string)
  default     = []
}

variable "enable_consul_ui" {
  description = "Whether to allow Consul UI/API (8500) from consul_ui_cidr_allowlist"
  type        = bool
  default     = false
}

variable "consul_ui_cidr_allowlist" {
  description = "CIDR allowlist for Consul UI/API (8500) if enabled"
  type        = list(string)
  default     = []
}

variable "enable_jenkins_ui" {
  description = "Whether to allow access to Jenkins UI (8080) from allowlist"
  type        = bool
  default     = false
}

variable "jenkins_ui_cidr_allowlist" {
  description = "CIDR allowlist for Jenkins UI access (8080) if enabled"
  type        = list(string)
  default     = []
}
