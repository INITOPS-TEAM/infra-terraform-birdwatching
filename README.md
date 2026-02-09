# infra-terraform-birdwatching

Terraform codebase for AWS lab infrastructure.

Provisions and manages:
- S3 remote backend for Terraform state (native S3 locking)
- VPC, subnets, routing
- Security groups
- EC2 instances (LB,app-1,app-2,DB)
- IAM role and instance profile for AWS SSM

---
## Requirements

- Terraform ~> 1.6
- AWS CLI v2
- AWS account with EC2, VPC, IAM, S3 permissions

---
## Backend

Terraform state is stored in S3 with native locking (no DynamoDB).

```bash
export AWS_PROFILE=iac
export AWS_REGION=eu-central-1
terraform init
```

---
## Repository structure

```
├── modules/        
│   ├── compute/    
│   ├── network/        
│   ├── s3/ 
│   └── security/   
├── .gitignore          
├── .terraform.lock.hcl 
├── README.md           
├── backend.tf          
├── provider.tf         
├── main.tf             
├── variables.tf    
└── outputs.tf      
```
## Root files overview

- **`backend.tf`**  
  Configures Terraform backend (where state is stored). Changes here may affect state location - handle with care
- **`provider.tf`**  
  Defines the AWS provider and global settings (region, profile).
- **`main.tf`**  
  Root module entry point. Instantiates child modules from `modules/` and connects them together.
- **`variables.tf`**
  Input variables for the root module (environment-wide configuration).
- **`outputs.tf`**
  Values exported from the infrastructure (instance IPs, IDs, etc).
- **`.terraform.lock.hcl`**
  Locks provider versions to ensure reproducible builds.

---

## Modules

Each directory under `modules/` is a self-contained Terraform module with its own:

- `main.tf`
- `variables.tf`
- `outputs.tf`
- `README.md`

Modules are not applied directly - they are consumed from `main.tf` in the root module.

---
## Configuration

Environment-specific values are passed via `-var-file`.

Example:
```hcl
aws_profile = "iac"
aws_region  = "eu-central-1"
name        = "pictapp-dev"
key_name    = "<existing_ec2_keypair_name>"
```

---
## Usage

```bash
terraform fmt -recursive
terraform validate
terraform plan  -var-file=envs/dev.tfvars
terraform apply -var-file=envs/dev.tfvars
```

---
## Notes
- Ubuntu 24.04 LTS is used for all EC2 instances
- All instances have an SSM role attached
- Instances currently run in public subnets (lab setup, no NAT)
- App and DB ports are restricted via security groups

