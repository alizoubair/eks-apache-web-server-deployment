# Test CodeBuild Project
resource "aws_codebuild_project" "codebuild_test_project" {
  name         = "${var.project_prefix}-codebuild-test"
  description  = "Test CodeBuild Project"
  service_role = var.codebuild_role_arn

  artifacts {
    type = var.source_type
  }

  source {
    type      = var.source_type
    buildspec = var.testspec_path
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.codebuild_bucket.bucket
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:7.0"
    type         = "LINUX_CONTAINER"
    
    environment_variable {
      name  = "GITHUB_REPOSITORY"
      value = var.github_repository
    }
  }
  logs_config {
    cloudwatch_logs {
      group_name  = "codebuild-test-log-group"
      stream_name = "codebuild-test-log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codebuild_bucket.id}/build-log"
    }
  }
}

# Deploy CodeBuild Project
resource "aws_codebuild_project" "codebuild_deploy_project" {
  name         = "${var.project_prefix}-codebuild-deploy"
  description  = "Deploy CodeBuild Project"
  service_role = var.codebuild_role_arn

  artifacts {
    type = var.source_type
  }

  source {
    type      = var.source_type
    buildspec = var.deployspec_path
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.codebuild_bucket.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    
    environment_variable {
      name  = "AWS_REGION"
      value = var.region
    }
    
    environment_variable {
      name  = "EKS_CLUSTER_NAME"
      value = var.cluster_name
    }
    
    environment_variable {
      name  = "ASSUME_ROLE_ARN"
      value = var.codebuild_role_arn
    }

    environment_variable {
      name  = "CSI_DRIVER_ROLE_ARN"
      value = var.csi_driver_role_arn
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "codebuild-deploy-log-group"
      stream_name = "codebuild-deploy-log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codebuild_bucket.id}/deploy-log"
    }
  }
}