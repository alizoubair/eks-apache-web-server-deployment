# VPC Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

# EKS Outputs
output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_oidc_issuer_url" {
  description = "EKS cluster OIDC issuer URL"
  value       = module.eks.cluster_oidc_issuer_url
}

# CSI Driver
output "csi_driver_role_arn" {
  description = "EBS CSI Driver IAM role ARN"
  value       = module.csi_driver.ebs_csi_role_arn
}

# EventBridge Outputs
output "event_bus_name" {
  description = "Custom EventBridge bus name"
  value       = module.eventbridge.event_bus_name
}

# IAM Outputs
output "eks_codebuild_role_arn" {
  description = "EKS CodeBuild IAM role ARN"
  value       = module.iam.eks_codebuild_role_arn
}

# Local Values
output "account_id" {
  description = "AWS Account ID"
  value       = local.account_id
}

output "region" {
  description = "AWS Region"
  value       = local.region
}