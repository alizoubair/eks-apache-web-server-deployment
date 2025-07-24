# EKS Module

Creates EKS cluster with managed node groups.

## Resources

- EKS cluster with specified version
- Managed node group with auto-scaling
- Public endpoint access enabled
- Private subnets for worker nodes

## Variables

- `project_prefix` - Resource naming prefix
- `vpc_id` - VPC ID from VPC module
- `private_subnets` - Private subnet IDs
- `cluster_version` - EKS version (default: 1.28)
- `node_instance_types` - Instance types (default: t3.small)
- `node_min_size` - Min nodes (default: 1)
- `node_max_size` - Max nodes (default: 3)
- `node_desired_size` - Desired nodes (default: 2)

## Outputs

- `cluster_name` - EKS cluster name
- `cluster_endpoint` - Cluster API endpoint
- `cluster_oidc_issuer_url` - OIDC issuer URL

## Testing

Run module tests:

```bash
cd tests/
terraform init -backend=false
terraform test
```

Tests validate:
- EKS cluster creation with correct naming
- Node group configuration
- OIDC issuer URL format