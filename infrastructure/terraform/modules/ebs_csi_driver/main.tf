# Data sources for current AWS account and region
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Get OIDC provider data
data "aws_iam_openid_connect_provider" "eks" {
  url = var.cluster_oidc_issuer_url
}

# EBS CSI Driver IAM Role for service account
resource "aws_iam_role" "ebs_csi_role" {
  name = "${var.project_prefix}-ebs-csi-driver-role"

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
            "${replace(data.aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
            "${replace(data.aws_iam_openid_connect_provider.eks.url, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_prefix}-ebs-csi-driver-role"
    Project     = var.project_prefix
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

# EBS CSI Driver IAM policy
resource "aws_iam_role_policy" "ebs_csi_policy" {
  name = "${var.project_prefix}-AmazonEKS_EBS_CSI_Driver_Policy"
  role = aws_iam_role.ebs_csi_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateSnapshot",
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:ModifyVolume",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInstances",
          "ec2:DescribeSnapshots",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumesModifications"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = ["ec2:CreateTags"]
        Resource = [
          "arn:aws:ec2:*:*:volume/*",
          "arn:aws:ec2:*:*:snapshot/*"
        ]
      },
      {
        Effect   = "Allow"
        Action   = ["ec2:CreateVolume"]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["ec2:DeleteVolume"]
        Resource = "*"
      }
    ]
  })
}