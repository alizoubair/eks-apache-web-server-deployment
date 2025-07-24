run "eks_validation" {
  command = plan

  variables {
    project_prefix = "test-project"
    cluster_version = "1.28"
    vpc_id = "vpc-12345"
    private_subnets = ["subnet-1", "subnet-2", "subnet-3"]
    node_instance_types = ["t3.medium"]
    node_min_size = 1
    node_max_size = 3
    node_desired_size = 2
  }

  assert {
    condition     = var.cluster_version == "1.28"
    error_message = "EKS cluster version should be 1.28"
  }

  assert {
    condition     = length(var.private_subnets) > 0
    error_message = "EKS should have private subnets configured"
  }

  assert {
    condition     = var.node_min_size <= var.node_desired_size && var.node_desired_size <= var.node_max_size
    error_message = "Node group sizing should be valid (min <= desired <= max)"
  }
}