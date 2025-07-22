# S3 bucket for CodePipeline artifacts storage
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = "codepipeline-${var.region}-${var.account_id}"
  force_destroy = true

  tags = {
    Name        = "${var.project_prefix}-codepipeline-bucket"
    Project     = var.project_prefix
    Environment = "development"
    ManagedBy   = "terraform"
    Purpose     = "codepipeline-artifacts"
  }
}

# Server-side encryption for CodePipeline S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "codepipeline_s3_sse" {
  bucket = aws_s3_bucket.codepipeline_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access for CodePipeline S3 bucket
resource "aws_s3_bucket_public_access_block" "cpl_bkt_block_public_access" {
  bucket = aws_s3_bucket.codepipeline_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket for CodeBuild artifacts and cache
resource "aws_s3_bucket" "codebuild_bucket" {
  bucket        = "codebuild-${var.region}-${var.account_id}"
  force_destroy = true

  tags = {
    Name        = "${var.project_prefix}-codebuild-bucket"
    Project     = var.project_prefix
    Environment = "development"
    ManagedBy   = "terraform"
    Purpose     = "codebuild-artifacts"
  }
}

# Server-side encryption for CodeBuild S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "codebuild_s3_sse" {
  bucket = aws_s3_bucket.codebuild_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access for CodeBuild S3 bucket
resource "aws_s3_bucket_public_access_block" "cb_bkt_block_public_access" {
  bucket = aws_s3_bucket.codebuild_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}