#!/bin/bash

# Two-stage Terraform apply to handle OIDC dependency
set -e

cd ../infrastructure/terraform

echo "🎯 Stage 1: Applying EKS cluster and dependencies..."
terraform apply -target=module.vpc -target=module.eks -target=module.csi_driver -target=module.cicd -target=module.eventbridge -auto-approve

echo "🎯 Stage 2: Applying remaining resources including OIDC-dependent IAM resources..."
terraform apply -auto-approve

echo "✅ Terraform apply completed successfully!"