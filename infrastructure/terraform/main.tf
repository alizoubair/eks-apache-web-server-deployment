# Root module for EKS infrastructure

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  project_prefix = var.project_prefix
  vpc_cidr       = var.vpc_cidr
}

# CI/CD Module
module "cicd" {
  source = "./modules/cicd"

  project_prefix        = var.project_prefix
  codebuild_role_arn    = module.iam.codebuild_role_arn
  codepipeline_role_arn = module.iam.codepipeline_role_arn
  github_repository     = var.github_repository
  account_id            = local.account_id
  region                = local.region
  cluster_name          = module.eks.cluster_name
  csi_driver_role_arn   = module.csi_driver.ebs_csi_role_arn
}

# EKS Module
module "eks" {
  source = "./modules/eks"

  project_prefix      = var.project_prefix
  vpc_id              = module.vpc.vpc_id
  private_subnets     = module.vpc.private_subnets
  cluster_version     = var.cluster_version
  node_instance_types = var.node_instance_types
  admin_user_name     = var.admin_user_name
  account_id          = local.account_id

  depends_on = [module.vpc]
}

# CSI Driver Module
module "csi_driver" {
  source = "./modules/ebs_csi_driver"

  project_prefix          = var.project_prefix
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url

  depends_on = [module.eks]
}

# IAM Module
module "iam" {
  source = "./modules/iam"

  project_prefix          = var.project_prefix
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  codepipeline_name       = module.cicd.codepipeline_name
  custom_event_bus_arn    = module.eventbridge.custom_event_bus_arn
  github_connection_arn   = module.cicd.github_connection_arn

  depends_on = [module.eks]
}

# EventBridge Module (optional - for CI/CD integration)
module "eventbridge" {
  source = "./modules/eventbridge"

  project_prefix                       = var.project_prefix
  github_connection_arn                = module.cicd.github_connection_arn
  account_id                           = local.account_id
  region                               = local.region
  eventbridge_event_routing_role_arn   = module.iam.eventbridge_event_routing_role_arn
  eventbridge_invoke_pipeline_role_arn = module.iam.eventbridge_invoke_pipeline_role_arn
}