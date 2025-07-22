run "cicd_validation" {
  command = plan

  variables {
    project_prefix        = "test-project"
    codepipeline_role_arn = "arn:aws:iam::123456789012:role/test-codepipeline-role"
    codebuild_role_arn    = "arn:aws:iam::123456789012:role/test-codebuild-role"
    github_repository     = "test-repo"
    region               = "us-west-2"
    account_id           = "123456789012"
  }

  assert {
    condition     = aws_codebuild_project.codebuild_test_project.name == "${var.project_prefix}-codebuild-test"
    error_message = "CodeBuild test project name should include project prefix"
  }

  assert {
    condition     = aws_s3_bucket.codepipeline_bucket.bucket == "codepipeline-${var.region}-${var.account_id}"
    error_message = "CodePipeline S3 bucket should be created"
  }

  assert {
    condition     = aws_codestarconnections_connection.github.name == "${var.project_prefix}-github-connection"
    error_message = "GitHub connection should be created with project prefix"
  }
}