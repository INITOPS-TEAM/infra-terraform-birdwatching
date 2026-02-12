aws_profile = "iac"
aws_region  = "eu-central-1"
bucket_name = "infra-terraform-9983988120210-dev"

name = "pictapp-dev"

key_name            = "pictapp-dev"
associate_public_ip = true

vpc_cidr = "10.10.0.0/16"

azs = [
  "eu-central-1a",
  "eu-central-1b"
]

public_subnet_cidrs = [
  "10.10.10.0/24",
  "10.10.11.0/24"
]

app_port = 5000

enable_ssh         = true
ssh_cidr_allowlist = ["0.0.0.0/0"]

enable_consul_ui         = false
consul_ui_cidr_allowlist = []

enable_jenkins_ui         = true
jenkins_ui_cidr_allowlist = ["0.0.0.0/0"]

instance_type_jenkins = "t3.small"
instance_type_lb = "t3.micro"
instance_type_app = "t3.micro"
instance_type_db = "t3.micro"
instance_type_consul = "t3.micro"
