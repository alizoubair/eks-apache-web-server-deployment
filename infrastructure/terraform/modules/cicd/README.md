# CICD Module

Creates CI/CD pipeline infrastructure with S3, GitHub connection, and CodeBuild.

## Resources

- S3 bucket for CodePipeline artifacts with encryption
- GitHub CodeStar connection
- CodeBuild project for deployment
- IAM roles and policies for CodeBuild

## Variables

- `project_prefix` - Resource naming prefix
- `region` - AWS Region
- `account_id` - AWS Account ID
- `cluster_name` - EKS cluster name for deployment
- `github_repo` - GitHub repository name
- `github_owner` - GitHub repository owner

## Outputs

- `codepipeline_bucket_name` - S3 bucket name
- `github_connection_arn` - GitHub connection ARN
- `codebuild_project_name` - CodeBuild project name
- `codebuild_role_arn` - CodeBuild IAM role ARN

## Usage

Provides complete CI/CD infrastructure for automated EKS deployments. CodeBuild uses `pipeline_files/deployspec.yml` for build instructions.

## Testing

Run module tests:

```bash
cd tests/
terraform init -backend=false
terraform test
```

Tests validate:
- S3 bucket creation for artifacts
- CodeBuild project configuration
- GitHub connection setup
- IAM role permissions