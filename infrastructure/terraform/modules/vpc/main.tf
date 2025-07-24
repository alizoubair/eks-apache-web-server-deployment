# VPC module for EKS cluster
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.9.0"

  name = "${var.project_prefix}-vpc"
  cidr = var.vpc_cidr
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  # Private subnets for EKS worker nodes
  private_subnets = var.private_subnets
  # Public subnets for load balancers
  public_subnets = var.public_subnets

  # NAT gateway for private subnet internet access
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_prefix}-vpc"
    Project     = var.project_prefix
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

# Get available AZs in current region
data "aws_availability_zones" "available" {
  state = "available"
}