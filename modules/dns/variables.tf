variable "domain_name" {
  description = "Public Route 53 hosted zone name"
  type        = string
}

variable "ipv4_address" {
  description = "IPv4 address for root domain"
  type        = string
}

variable "ttl" {
  description = "TTL for the A record"
  type        = number
  default     = 300
}
