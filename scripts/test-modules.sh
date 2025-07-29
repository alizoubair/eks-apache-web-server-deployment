#!/bin/bash

# Test all Terraform modules locally
set -e

MODULES_DIR="../infrastructure/terraform/modules"
MODULES=("vpc" "eks" "iam" "eventbridge" "cicd")

echo "🧪 Testing Terraform modules..."

FAILED_MODULES=()

for module in "${MODULES[@]}"; do
    echo "📦 Testing module: $module"
    cd "$MODULES_DIR/$module"
    
    if [ -d "tests" ]; then
        terraform init -backend=false
        if terraform test; then
            echo "✅ $module tests passed"
        else
            echo "❌ $module tests failed"
            FAILED_MODULES+=("$module")
        fi
    else
        echo "⚠️  No tests found for $module"
    fi
    
    cd - > /dev/null
    echo ""
done

if [ ${#FAILED_MODULES[@]} -eq 0 ]; then
    echo "🎉 All module tests completed successfully!"
else
    echo "⚠️ The following modules had test failures:"
    for failed in "${FAILED_MODULES[@]}"; do
        echo "  - $failed"
    done
    exit 1
fi