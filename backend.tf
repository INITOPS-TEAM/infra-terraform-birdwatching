terraform {
  backend "s3" {
    bucket  = "infra-terraform-9983988120210-state"
    key     = "birdwatching/dev/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}
