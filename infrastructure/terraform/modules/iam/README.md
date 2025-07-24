# IAM Module

Creates IAM roles and OIDC provider for EKS service accounts.

## Resources

- OIDC provider for EKS cluster
- ADOT collector IAM role with web identity
- Managed policy attachment for Prometheus access

## Variables

- `project_prefix` - Resource naming prefix
- `cluster_oidc_issuer_url` - EKS OIDC issuer URL

## Outputs

- `adot_collector_role_arn` - ADOT collector role ARN
- `oidc_provider_arn` - OIDC provider ARN

## Usage

Enables Kubernetes service accounts to assume AWS IAM roles for accessing AWS services like CloudWatch and Prometheus.

## Testing

Run module tests:

```bash
cd tests/
terraform init -backend=false
terraform test
```

Tests validate:
- IAM role creation with correct naming
- OIDC provider configuration
- Policy attachments