# VPC Module

Creates VPC with public/private subnets for EKS cluster.

## Resources

- VPC with configurable CIDR
- 3 private subnets for EKS nodes
- 3 public subnets for load balancers
- NAT gateway for internet access
- DNS hostnames enabled

## Variables

- `project_prefix` - Resource naming prefix
- `vpc_cidr` - VPC CIDR block (default: 10.0.0.0/16)
- `private_subnets` - Private subnet CIDRs
- `public_subnets` - Public subnet CIDRs

## Outputs

- `vpc_id` - VPC ID
- `private_subnets` - Private subnet IDs
- `public_subnets` - Public subnet IDs

## Testing

Run module tests:

```bash
cd tests/
terraform init -backend=false
terraform test
```

Tests validate:
- VPC creation with correct naming
- Subnet configuration and tagging
- NAT gateway setup