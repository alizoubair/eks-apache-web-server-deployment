output "adot_collector_role_arn" {
  description = "ADOT collector IAM role ARN"
  value       = aws_iam_role.adot_collector_role.arn
}

output "oidc_provider_arn" {
  description = "EKS OIDC provider ARN"
  value       = data.aws_iam_openid_connect_provider.eks.arn
}

output "eventbridge_event_routing_role_arn" {
  description = "EventBridge event routing IAM role ARN"
  value       = aws_iam_role.eventbridge_event_routing_role.arn
}

output "eventbridge_invoke_pipeline_role_arn" {
  description = "EventBridge invoke pipeline IAM role ARN"
  value       = aws_iam_role.eventbridge_invoke_pipeline_role.arn
}

output "codebuild_role_arn" {
  description = "CodeBuild IAM role ARN"
  value       = aws_iam_role.codebuild_role.arn
}

output "codepipeline_role_arn" {
  description = "CodePipeline IAM role ARN"
  value       = aws_iam_role.codepipeline_role.arn
}

output "eks_codebuild_role_arn" {
  description = "EKS CodeBuild IAM role ARN"
  value       = aws_iam_role.eks_codebuild_role.arn
}