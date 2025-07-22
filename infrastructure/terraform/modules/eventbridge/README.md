# EventBridge Module

Creates EventBridge rules for CI/CD automation.

## Resources

- Custom EventBridge bus
- Event rule for GitHub repository changes
- IAM role for pipeline execution
- EventBridge target to trigger CodePipeline

## Variables

- `project_prefix` - Resource naming prefix
- `github_connection_arn` - GitHub CodeStar connection ARN
- `codepipeline_name` - Pipeline name to trigger
- `account_id` - AWS Account ID
- `region` - AWS Region

## Outputs

- `event_bus_name` - EventBridge bus name
- `event_bus_arn` - EventBridge bus ARN
- `eventbridge_role_arn` - EventBridge IAM role ARN

## Usage

Automatically triggers CodePipeline when changes are pushed to main branch of connected GitHub repository.

## Testing

Run module tests:

```bash
cd tests/
terraform init -backend=false
terraform test
```

Tests validate:
- EventBridge bus creation with correct naming
- Event rule configuration
- IAM role permissions