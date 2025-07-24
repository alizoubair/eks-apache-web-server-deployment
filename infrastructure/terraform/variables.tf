variable "project_prefix" {
  description = "Project prefix for resource naming"
  type        = string
  default     = "eks-apache"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.28"
}

variable "node_instance_types" {
  description = "Node group instance types"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "github_repository" {
  type        = string
  description = "GitHub repository identifier in the format org/repo"
}

variable "github_access_token" {
  type        = string
  description = "GitHub Personal Access Token"
  sensitive   = true
}

variable "admin_user_name" {
  description = "IAM user name for EKS admin access"
  type        = string
}