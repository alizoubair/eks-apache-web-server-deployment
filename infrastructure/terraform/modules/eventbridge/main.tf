# Create custom event bus
resource "aws_cloudwatch_event_bus" "custom_event_bus" {
  name = "${var.project_prefix}-custom-event-bus"

  tags = {
    Name        = "${var.project_prefix}-custom-event-bus"
    Project     = var.project_prefix
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

# Rule to route events to custom bus
resource "aws_cloudwatch_event_rule" "custom_event_rule" {
  name          = "${var.project_prefix}-event_rule-main-branch"
  role_arn      = var.eventbridge_event_routing_role_arn
  force_destroy = "true"
  event_pattern = jsonencode({
    "source" : ["aws.codestar-connections"],
    "detail-type" : ["CodeStar Connections Repository Event"],
    "resources" : [var.github_connection_arn],
    "detail" : {
      "event" : ["referenceCreated", "referenceUpdated"],
      "referenceType" : ["branch"],
      "referenceName" : ["main"]
    }
  })

  tags = {
    Name        = "${var.project_prefix}-event_rule-main-branch"
    Project     = var.project_prefix
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

# Target to route events to custom bus
resource "aws_cloudwatch_event_target" "custom_event_target" {
  rule          = aws_cloudwatch_event_rule.custom_event_rule.name
  force_destroy = "true"
  target_id     = aws_cloudwatch_event_bus.custom_event_bus.name
  arn           = aws_cloudwatch_event_bus.custom_event_bus.arn
  role_arn      = var.eventbridge_event_routing_role_arn
}

# Rule to invoke pipeline from custom bus
resource "aws_cloudwatch_event_rule" "invoke_codepipeline_event_rule" {
  name           = "${var.project_prefix}-codepipeline_event_rule-main-branch"
  event_bus_name = aws_cloudwatch_event_bus.custom_event_bus.name
  role_arn       = var.eventbridge_invoke_pipeline_role_arn
  force_destroy  = "true"
  event_pattern = jsonencode({
    "source" : ["aws.codestar-connections"],
    "detail-type" : ["CodeStar Connections Repository Event"],
    "resources" : [var.github_connection_arn],
    "detail" : {
      "event" : ["referenceCreated", "referenceUpdated"],
      "referenceType" : ["branch"],
      "referenceName" : ["main"]
    }
  })

  tags = {
    Name        = "${var.project_prefix}-codepipeline_event_rule-main-branch"
    Project     = var.project_prefix
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

# Target to invoke pipeline from custom bus
resource "aws_cloudwatch_event_target" "codepipeline_event_target" {
  rule           = aws_cloudwatch_event_rule.invoke_codepipeline_event_rule.name
  target_id      = "main-branch-pipeline"
  force_destroy  = "true"
  arn            = "arn:aws:codepipeline:${var.region}:${var.account_id}:YOUR_PIPELINE_NAME"
  role_arn       = var.eventbridge_invoke_pipeline_role_arn
  event_bus_name = aws_cloudwatch_event_bus.custom_event_bus.arn
}
