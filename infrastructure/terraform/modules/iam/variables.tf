variable "project_prefix" {
  description = "Project prefix for resource naming"
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "EKS cluster OIDC issuer URL"
  type        = string
  default     = null
}

variable "custom_event_bus_arn" {
  description = "Custom event bus ARN"
  type        = string
}

variable "github_connection_arn" {
  description = "GitHub CodeStar connection ARN (optional)"
  type        = string
}

variable "codepipeline_name" {
  description = "CodePipeline name"
  type        = string
}