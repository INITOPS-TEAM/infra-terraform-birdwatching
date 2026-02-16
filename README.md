# infra-terraform-birdwatching

Terraform codebase for AWS lab infrastructure.

Provisions and manages:
- S3 remote backend for Terraform state (native S3 locking)
- VPC, subnets, routing
- Security groups
- EC2 instances (LB, app-1, app-2, DB, Consul, Jenkins)
- Elastic IP for the Load Balancer
- Route 53 DNS apex A record
- IAM role and instance profile for AWS SSM

---
## Requirements

- Terraform v1.14.4
- AWS CLI v2
- AWS account with EC2, VPC, IAM, S3 permissions

---
## Repository structure

```
├── bootstrap/
├── envs/
│   ├── dev.tfvars
│   ├── stage.tfvars
│   ├── prod.tfvars
├── modules/        
│   ├── compute/    
│   ├── network/        
│   ├── s3/
│   ├── dns/
│   └── security/        
├── backend.tf          
├── provider.tf         
├── main.tf             
├── variables.tf
├── outputs.tf  
└── .terraform.lock.hcl
```
## Root files overview

- **`backend.tf`**  
  Declares Terraform remote state.
- **`provider.tf`**  
  AWS provider configuration (for region and profile use variables).
- **`main.tf`**  
  Root module entry point. Instantiates child modules from `modules/` and connects them.
- **`variables.tf`**
  Input variables for the root module (environment-wide configuration).
- **`outputs.tf`**
  Values exported from the infrastructure.
- **`.terraform.lock.hcl`**
  Locks provider versions to ensure reproducible builds.

---

## Environments

Environment-specific values are defined in:

- `envs/dev.tfvars`
- `envs/stage.tfvars`
- `envs/prod.tfvars`

Environment-specific values are passed via `-var-file`.

---
## Usage

### 1. Backend

Terraform state is stored in S3 with native locking (no DynamoDB). Each environment has a dedicated backend configuration file.

Backend configs:

- `backend-eun-1-dev.hcl`
- `backend-eun-1-stage.hcl`
- `backend-eun-1-prod.hcl`

Initialize Terraform for a specific environment (run once per environment or whenever backend configuration changes):

```
export AWS_PROFILE=iac
export AWS_REGION=eu-north-1

terraform init -reconfigure -backend-config=backend-eun1-dev.hcl
```
Always ensure backend config matches the environment you are targeting.

After backend is initialized, regular runs only require:

```
terraform init
```

### 2. Plan

```
terraform plan -var-file=envs/dev.tfvars
```
### 3. Apply

```
terraform apply -var-file=envs/dev.tfvars
```
`-var-file` must always correspond to the same environment.

---
## Notes
- Ubuntu 24.04 LTS is used for all EC2 instances
- All instances have an SSM role attached
- Instances currently run in public subnets (lab setup, no NAT)
- Load Balancer uses a managed Elastic IP.
- DNS apex record is managed via the `dns` module and points to the LB Elastic IP.


