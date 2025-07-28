#!/bin/bash

# Terraform destroy script
set -e

cd ../infrastructure/terraform

echo "🔥 Destroying Terraform resources..."
terraform destroy -auto-approve

echo "✅ Terraform destroy completed successfully!"