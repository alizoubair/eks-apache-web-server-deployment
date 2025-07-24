# EKS Infrastructure Module

Modular Terraform configuration for EKS cluster with VPC, IAM, and optional EventBridge.

## Modules

- **vpc**: VPC with public/private subnets
- **eks**: EKS cluster with managed node groups
- **iam**: OIDC provider and ADOT collector role
- **eventbridge**: EventBridge rules for CI/CD (optional)
- **cicd**: CI/CD pipeline with S3, GitHub, CodeBuild (optional)
- **ebs_csi_driver**: EBS CSI driver for persistent volume support

## Usage

```bash
# Initialize
terraform init

# Plan with variables
terraform plan -var-file="terraform.tfvars"

# Apply
terraform apply -var-file="terraform.tfvars"
```

## Variables

Copy `terraform.tfvars.example` to `terraform.tfvars` and customize:

- `project_prefix`: Resource naming prefix
- `vpc_cidr`: VPC CIDR block
- `cluster_version`: EKS version
- `node_instance_types`: Node group instance types
- `github_connection_arn`: Optional GitHub connection for CI/CD
- `codepipeline_name`: Optional pipeline name for EventBridge
- `enable_cicd`: Enable CI/CD module deployment

## Outputs

- VPC ID and subnet IDs
- EKS cluster details
- IAM role ARNs
- EventBridge bus name (if enabled)
- CI/CD resources (if enabled)
- AWS account ID and region