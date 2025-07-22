resource "aws_codepipeline" "codepipeline" {
  name     = "${var.project_prefix}-codepipeline"
  role_arn = var.codepipeline_role_arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  # Clone from GitHub and store contents in artifacts S3 Buckets
  stage {
    name = "Source"

    action {
      name     = "Source"
      category = "Source"
      owner    = "AWS"
      provider = "CodeStarSourceConnection"
      version  = "1"
      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github.arn
        FullRepositoryId = var.github_repository
        BranchName       = var.branch_name
      }
      input_artifacts  = []
      output_artifacts = ["source_output_artifacts"]
      run_order        = 1
    }
  }

  # Run Terraform Test Framework
  stage {
    name = "Build_TF_Test"
    action {
      name     = "Build_TF_Test"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"
      configuration = {
        ProjectName = aws_codebuild_project.codebuild_test_project.name
      }
      input_artifacts  = ["source_output_artifacts"]
      output_artifacts = ["build_tf_test_output_artifacts"]
      run_order        = 2
    }
  }

  # Apply Terraform
  stage {
    name = "Build_TF_Deploy"
    action {
      name     = "Build_TF_Deploy"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"
      configuration = {
        ProjectName = aws_codebuild_project.codebuild_deploy_project.name
      }
      input_artifacts  = ["source_output_artifacts"]
      output_artifacts = ["build_tf_deploy_output_artifacts"]
      run_order        = 3
    }
  }
}