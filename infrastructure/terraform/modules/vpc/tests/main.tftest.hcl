run "vpc_validation" {
  command = plan

  variables {
    project_prefix = "test-project"
    vpc_cidr = "10.0.0.0/16"
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  }

  assert {
    condition     = var.vpc_cidr == "10.0.0.0/16"
    error_message = "VPC CIDR should be 10.0.0.0/16"
  }

  assert {
    condition     = length(var.private_subnets) == 3
    error_message = "Should have 3 private subnets configured"
  }

  assert {
    condition     = length(var.public_subnets) == 3
    error_message = "Should have 3 public subnets configured"
  }
}