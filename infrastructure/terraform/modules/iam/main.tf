# Data sources for current AWS account and region
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# IAM Role for EventBridge to invoke pipeline
resource "aws_iam_role" "eventbridge_event_routing_role" {
  name = "${var.project_prefix}-eventbridge-event-routing-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "events.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.project_prefix}-eventbridge-event-routing-role"
    Project     = var.project_prefix
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

# IAM Policy for EventBridge to invoke pipeline
resource "aws_iam_role_policy" "eventbridge_event_routing_policy" {
  name = "${var.project_prefix}-eventbridge-event-routing-policy"
  role = aws_iam_role.eventbridge_event_routing_role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "events:PutEvents"
        ],
        "Resource" : [
          var.custom_event_bus_arn
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "codestar-connections:UseConnection"
        ],
        "Resource" : [
          var.github_connection_arn
        ]
      }
    ]
  })
}

# IAM Role for EventBridge to invoke pipeline
resource "aws_iam_role" "eventbridge_invoke_pipeline_role" {
  name = "${var.project_prefix}-eventbridge-invoke-pipeline-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "events.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.project_prefix}-eventbridge-invoke-pipeline-role"
    Project     = var.project_prefix
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

# IAM Policy for EventBridge to invoke pipeline
resource "aws_iam_role_policy" "eventbridge_invoke_pipeline_policy" {
  name = "${var.project_prefix}-eventbridge-invoke-pipeline-policy"
  role = aws_iam_role.eventbridge_invoke_pipeline_role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "codepipeline:StartPipelineExecution"
        ],
        "Resource" : [
          "arn:aws:codepipeline:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.codepipeline_name}"
        ]
      }
    ]
  })
}

# IAM Role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "${var.project_prefix}-codebuild-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "codebuild.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.project_prefix}-codebuild-role"
    Project     = var.project_prefix
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

# IAM Role for CodeBuild to access EKS
resource "aws_iam_role" "eks_codebuild_role" {
  name = "${var.project_prefix}-eks-codebuild-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.project_prefix}-codebuild-role"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.project_prefix}-eks-codebuild-role"
    Project     = var.project_prefix
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

# IAM Policy for CodePipeline to invoke pipeline
resource "aws_iam_role_policy" "codebuild_policy" {
  name = "${var.project_prefix}-codebuild-policy"
  role = aws_iam_role.codebuild_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "iam:GetRole",
          "iam:ListRolePolicies",
          "iam:GetRolePolicy",
          "iam:ListAttachedRolePolicies",
          "iam:PutRolePolicy",
          "iam:UpdateRole",
          "iam:DeleteRolePolicy",
          "iam:PassRole"
        ],
        Resource = ["*"]
      },
      {
        Effect = "Allow",
        Action = [
          "codestar-connections:GetConnection",
          "codestar-connections:PassConnection",
          "codestar-connections:ListTagsForResource"
        ],
        Resource = [
          var.github_connection_arn
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "events:*"
        ],
        Resource = ["*"]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = [
          "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:*"
        ],
        Resource = ["*"]
      },
      {
        Effect = "Allow",
        Action = [
          "codebuild:BatchGetProjects",
          "codebuild:UpdateProject"
        ],
        Resource = [
          "arn:aws:codebuild:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:project/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "codepipeline:GetPipeline",
          "codepipeline:ListTagsForResource",
          "codepipeline:UpdatePipeline",
          "codepipeline:GetPipeline",
          "codepipeline:GetPipelineState",
          "codepipeline:StartPipelineExecution"
        ],
        Resource = [
          "arn:aws:codepipeline:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:UpdateClusterConfig",
          "eks:DescribeUpdate",
          "eks:ListNodegroups",
          "eks:DescribeNodegroup",
          "eks:AccessKubernetesApi"
        ],
        Resource = ["*"]
      },
      {
        Effect = "Allow",
        Action = [
          "sts:AssumeRole"
        ],
        Resource = ["*"]
      },
      {
        Effect = "Allow",
        Action = [
          "sts:GetCallerIdentity"
        ],
        Resource = ["*"]
      }
    ]
  })
}

# IAM Role for CodePipeline
resource "aws_iam_role" "codepipeline_role" {
  name = "${var.project_prefix}-codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.project_prefix}-codepipeline-role"
    Project     = var.project_prefix
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

# IAM Policy for CodePipeline
resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${var.project_prefix}-codepipeline-policy"
  role = aws_iam_role.codepipeline_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning",
          "s3:PutObjectAcl",
          "s3:PutObject"
        ]
        Resource = ["*"]
      },
      {
        Effect = "Allow"
        Action = [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild",
          "codebuild:BatchGetBuildBatches",
          "codebuild:StartBuildBatch"
        ]
        Resource = [
          "arn:aws:codebuild:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:project/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "codestar-connections:UseConnection"
        ],
        "Resource" : [
          var.github_connection_arn
        ]
      }
    ]
  })
}

# Get OIDC provider data - handle case where it might not exist yet
data "aws_iam_openid_connect_provider" "eks" {
  url = var.cluster_oidc_issuer_url
}

# ADOT Collector IAM Role for service account
resource "aws_iam_role" "adot_collector_role" {
  name = "${var.project_prefix}-adot-collector-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.eks.arn
        }
        Condition = {
          StringEquals = {
            "${replace(data.aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:adot:adot-collector-opentelemetry-collector"
            "${replace(data.aws_iam_openid_connect_provider.eks.url, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_prefix}-adot-collector-role"
    Project     = var.project_prefix
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

# Attach managed policy for Prometheus remote write access
resource "aws_iam_role_policy_attachment" "adot_collector_policy" {
  role       = aws_iam_role.adot_collector_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonPrometheusRemoteWriteAccess"
}