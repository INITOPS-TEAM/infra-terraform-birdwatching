# infra-terraform-birdwatching

Terraform codebase for AWS lab infrastructure. Infrastructure is deployed in **eu-north-1** and follows a multi-environment structure using environment-specific tfvars files.

The project provisions:
- VPC with public subnets (no NAT)
- Security groups
- EC2 instances (LB, app-1, app-2, DB, Consul, Jenkins)
- IAM role and instance profile for AWS SSM
- Application S3 bucket (via `/modules/s3`)

Terraform state is stored remotely in S3 (separate backend bucket).

---
## Requirements

- Terraform ~> 1.6
- AWS CLI v2
- AWS account with EC2, VPC, IAM, S3 permissions

---
## Bootstrap (Terraform Backend initialization)

Terraform state is stored in S3 with native locking (no DynamoDB) in **eu-north-1**.

Because Terraform cannot use an S3 backend before the bucket exists, a separate `bootstrap/` configuration is provided.

Bootstrap backend (run once per region):

``` bash
cd bootstrap

export AWS_PROFILE=iac
export AWS_REGION=eu-north-1

terraform init
terraform apply
```

This creates S3 bucket for Terraform state. After successful execution, return to the root directory.

Initialize main infrastructure:

``` bash
cd ..

terraform init
```

If backend configuration was changed (during region migration):

``` bash
terraform init -reconfigure
terraform init -migrate-state
```

Always verify state after migration:

``` bash
terraform state list
```
---
## Repository structure

```
├── bootstrap/
│   ├── main.tf
│   ├── variables.tf
├── envs/
│   ├── dev.tfvars
│   ├── stage.tfvars.example
│   ├── prod.tfvars.example
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

- **bootstrap/**
  Separate Terraform configuration used only for creating the backend S3 bucket. Must be executed before initializing the main infrastructure.
- **`backend.tf`**  
  Defines Terraform backend (where state is stored).
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
## Multi-environment configuration

Environment-specific values are passed via 

    `-var-file=envs/<environment>.tfvars`

Example (dev):
```hcl
aws_profile = "iac"
aws_region  = "eu-north-1"
name        = "pictapp-dev"
key_name    = "<existing_ec2_keypair_name>"
```

---
## Usage (dev)

```bash
terraform plan -var-file=envs/dev.tfvars
terraform apply -var-file=envs/dev.tfvars
```

---
## Notes
- Ubuntu 24.04 LTS is used for all EC2 instances
- All instances have an SSM role attached
- Instances currently run in public subnets.
- Security groups allow internal SG-to-SG SSH communication.

