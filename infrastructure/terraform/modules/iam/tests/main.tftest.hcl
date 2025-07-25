mock_provider "aws" {
  mock_data "aws_iam_openid_connect_provider" {
    defaults = {
      arn = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-west-2.amazonaws.com/id/EXAMPLE"
      client_id_list = ["sts.amazonaws.com"]
      thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
      url = "https://oidc.eks.us-west-2.amazonaws.com/id/EXAMPLE"
    }
  }
  
  mock_data "aws_caller_identity" {
    defaults = {
      account_id = "123456789012"
      arn = "arn:aws:iam::123456789012:user/test"
      user_id = "AIDACKCEVSQ6C2EXAMPLE"
    }
  }
  
  mock_data "aws_region" {
    defaults = {
      name = "us-west-2"
    }
  }
}

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