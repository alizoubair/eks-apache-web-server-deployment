run "iam_validation" {
  command = validate

  variables {
    project_prefix           = "test-project"
    cluster_oidc_issuer_url  = "https://oidc.eks.us-west-2.amazonaws.com/id/EXAMPLE"
    custom_event_bus_arn     = "arn:aws:events:us-west-2:123456789012:event-bus/test-bus"
    github_connection_arn    = "arn:aws:codestar-connections:us-west-2:123456789012:connection/test-connection"
    codepipeline_name        = "test-pipeline"
  }

  assert {
    condition     = var.project_prefix == "test-project"
    error_message = "Project prefix should be set"
  }

  assert {
    condition     = length(var.github_connection_arn) > 0
    error_message = "GitHub connection ARN should be provided"
  }

  assert {
    condition     = length(var.custom_event_bus_arn) > 0
    error_message = "Event bus ARN should be provided"
  }
}