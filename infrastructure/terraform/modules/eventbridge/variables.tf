variable "project_prefix" {
  description = "Project prefix for resource naming"
  type        = string
}

variable "github_connection_arn" {
  description = "GitHub CodeStar connection ARN"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "eventbridge_event_routing_role_arn" {
  description = "EventBridge event routing role ARN"
  type        = string
}

variable "eventbridge_invoke_pipeline_role_arn" {
  description = "EventBridge invoke pipeline role ARN"
  type        = string
}