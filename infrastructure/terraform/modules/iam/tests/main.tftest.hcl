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
    condition     = aws_iam_role.adot_collector_role.name == "${var.project_prefix}-adot-collector-role"
    error_message = "ADOT collector role name should include project prefix"
  }

  assert {
    condition     = aws_iam_role.codebuild_role.name == "${var.project_prefix}-codebuild-role"
    error_message = "CodeBuild role name should include project prefix"
  }

  assert {
    condition     = length(aws_iam_openid_connect_provider.eks.client_id_list) > 0
    error_message = "OIDC provider should have client IDs configured"
  }
}