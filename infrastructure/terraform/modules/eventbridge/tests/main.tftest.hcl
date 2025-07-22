run "eventbridge_validation" {
  command = plan

  variables {
    project_prefix                        = "test-project"
    github_connection_arn                 = "arn:aws:codestar-connections:us-west-2:123456789012:connection/test"
    account_id                           = "123456789012"
    region                               = "us-west-2"
    eventbridge_event_routing_role_arn   = "arn:aws:iam::123456789012:role/test-event-routing-role"
    eventbridge_invoke_pipeline_role_arn = "arn:aws:iam::123456789012:role/test-invoke-pipeline-role"
  }

  assert {
    condition     = aws_cloudwatch_event_bus.custom_event_bus.name == "${var.project_prefix}-custom-event-bus"
    error_message = "EventBridge bus name should include project prefix"
  }

  assert {
    condition     = aws_cloudwatch_event_rule.custom_event_rule.name == "${var.project_prefix}-event_rule-main-branch"
    error_message = "EventBridge rule name should include project prefix"
  }
}