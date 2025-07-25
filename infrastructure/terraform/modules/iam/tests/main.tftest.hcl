run "iam_validation" {
  command = plan

  variables {
    project_prefix           = "test-project"
    cluster_oidc_issuer_url  = "https://oidc.eks.us-west-2.amazonaws.com/id/EXAMPLE"
    custom_event_bus_arn     = "arn:aws:events:us-west-2:123456789012:event-bus/test-bus"
    github_connection_arn    = "arn:aws:codestar-connections:us-west-2:123456789012:connection/test-connection"
    codepipeline_name        = "test-pipeline"
  }

  assert {
    condition     = aws_iam_role.codebuild_role.name == "${var.project_prefix}-codebuild-role"
    error_message = "CodeBuild role name should include project prefix"
  }

  assert {
    condition     = aws_iam_role.codepipeline_role.name == "${var.project_prefix}-codepipeline-role"
    error_message = "CodePipeline role name should include project prefix"
  }

  assert {
    condition     = aws_iam_role.eventbridge_event_routing_role.name == "${var.project_prefix}-eventbridge-event-routing-role"
    error_message = "EventBridge role name should include project prefix"
  }
}