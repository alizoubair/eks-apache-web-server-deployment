variable "project_prefix" {
  description = "Prefix for cloud resources"
  type        = string
}

variable "codepipeline_role_arn" {
  description = "ARN of the role to be used for CodePipeline"
  type        = string
}

variable "codebuild_role_arn" {
  description = "ARN of the role to be used for CodeBuild"
  type        = string
}

variable "source_type" {
  description = "Type of repository that contains the source code to be built. Valid values for this parameter are: CODECOMMIT, CODEPIPELINE, GITHUB, GITHUB_ENTERPRISE, BITBUCKET or S3"
  type        = string
  default     = "CODEPIPELINE"
}

variable "testspec_path" {
  description = "Path to the testspec file"
  type        = string
  default     = "pipeline_files/testspec.yml"
}

variable "deployspec_path" {
  description = "Path to the deployspec file"
  type        = string
  default     = "pipeline_files/deployspec.yml"
}

variable "github_repository" {
  description = "Name of the GitHub repository"
  type        = string
}
variable "branch_name" {
  description = "Name of the branch to be used for CodePipeline"
  type        = string
  default     = "main"
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}