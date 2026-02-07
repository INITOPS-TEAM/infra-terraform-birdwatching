# infra-terraform-birdwatching

Terraform setup for AWS IaC.

This repository initializes the AWS provider and provisions an S3 bucket as a Terraform-managed resource.

---

## Requirements

- Terraform >= 1.2
- AWS CLI v2
- AWS IAM user credentials
- AWS CLI profile configured (default: `iac`)

---

## Authentication

Terraform uses AWS CLI credentials via profile:

```
iac
```

Check available profiles:
```bash
aws configure list-profiles
```

---

## Structure

```
infra-terraform/
├── terraform.tf
├── provider.tf
├── variables.tf
├── main.tf
├── terraform.tfvars   # local only
├── .terraform.lock.hcl
└── README.md
```

---

## Configuration

S3 bucket name is provided via `terraform.tfvars`
(not committed to the repository):

```hcl
bucket_name = "infra-terraform-UNIQUE-dev"
```
Replace UNIQUE  with our account ID. 

---

## Usage

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

---

## Notes

- Terraform state is stored locally
- No AWS credentials are stored in the repository
- `.terraform/`, `*.tfstate`, `terraform.tfvars` are excluded from git

---

## Next Step

Deploy application runtime on AWS EC2 using Terraform.

