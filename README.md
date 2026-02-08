# infra-terraform-birdwatching

Terraform setup for AWS IaC. This repository manages AWS resources using Terraform. It provisions an S3 bucket and stores Terraform state in S3 with native locking.

---
## Requirements

- Terraform ~> 1.14
- AWS CLI v2
- AWS CLI profile configured locally
- AWS account with permissions to read/write the Terraform state bucket and manage S3 resources

---
## Authentication

Terraform uses AWS CLI credentials.

---
## Backend (S3 remote state) credentials

The S3 backend uses AWS credentials available at the time of `terraform init`.
Before running `terraform init`, set the required AWS profile and region:

```bash
export AWS_PROFILE=iac
export AWS_REGION=eu-central-1
terraform init
```

---
## Repository structure

```
infra-terraform/
├── backend.tf             # S3 remote backend configuration
├── provider.tf            # Terraform + AWS provider configuration
├── main.tf                # Root module (calls child modules)
├── variables.tf           # Root input variables
├── outputs.tf             # Root outputs
├── terraform.tfvars       # Local-only values (not committed)
├── .terraform.lock.hcl    # Provider dependency lock file
├── modules/
│   └── s3/
│       ├── bucket.tf      # S3 bucket resource
│       ├── variables.tf   # Module input variables
│       └── outputs.tf     # Module outputs
└── README.md
```

---
## Configuration

Environment-specific values are provided via `terraform.tfvars` (the file isn't commited to the repo).

Example values:

```hcl
aws_profile = "iac"
aws_region  = "eu-central-1"
bucket_name = "<s3_bucket_name>"
```

---
## Usage

Initialize Terraform (backend + modules):
```bash
export AWS_PROFILE=iac
export AWS_REGION=eu-central-1
terraform init
```

Validate configuration:
```bash
terraform validate
```

Preview changes:
```bash
terraform plan
```

Apply changes:
```bash
terraform apply
```

---
## Operational details

- Terraform state is stored in S3 remote backend
- Native S3 state locking is enabled (no DynamoDB)
- AWS provider version is pinned via `.terraform.lock.hcl`
- The managed S2 bucket resource is protected with `prevent_destroy`

