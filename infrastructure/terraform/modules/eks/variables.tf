variable "project_prefix" {
  description = "Project prefix for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnets" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.28"
}

variable "node_instance_types" {
  description = "Node group instance types"
  type        = list(string)
  default     = ["t3.small"]
}

variable "node_min_size" {
  description = "Node group minimum size"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Node group maximum size"
  type        = number
  default     = 1
}

variable "node_desired_size" {
  description = "Node group desired size"
  type        = number
  default     = 1
}

variable "admin_user_name" {
  description = "IAM user name for EKS admin access"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}