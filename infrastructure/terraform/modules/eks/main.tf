# EKS cluster module
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = "${var.project_prefix}-cluster"
  cluster_version = var.cluster_version

  # VPC configuration
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.private_subnets
  cluster_endpoint_public_access = true

  # Access entries for additional users
  access_entries = {
    admin_user = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::${var.account_id}:user/${var.admin_user_name}"
      
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  # Managed node groups
  eks_managed_node_groups = {
    main = {
      instance_types = var.node_instance_types
      min_size       = var.node_min_size
      max_size       = var.node_max_size
      desired_size   = var.node_desired_size
    }
  }

  tags = {
    Name        = "${var.project_prefix}-cluster"
    Project     = var.project_prefix
    Environment = "development"
    ManagedBy   = "terraform"
  }
}