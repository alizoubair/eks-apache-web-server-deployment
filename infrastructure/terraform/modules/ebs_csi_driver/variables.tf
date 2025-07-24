variable "project_prefix" {
  description = "Project prefix for resource naming"
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "EKS cluster OIDC issuer URL"
  type        = string
}