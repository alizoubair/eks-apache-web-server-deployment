#!/bin/bash

# Change to the Terraform directory
cd "$(dirname "$0")/../infrastructure/terraform" || exit 1

# Set variables
CLUSTER_NAME=$(terraform output -raw cluster_name 2>/dev/null)
REGION=$(terraform output -raw region 2>/dev/null)

# Check if variables were set correctly
if [ -z "$CLUSTER_NAME" ] || [ -z "$REGION" ]; then
  echo "Error: Could not get cluster_name or region from Terraform outputs."
  echo "Make sure you're running this script from the repository root or Terraform has been applied."
  exit 1
fi

# Update kubeconfig
echo "Updating kubeconfig for cluster ${CLUSTER_NAME}..."
aws eks update-kubeconfig --region ${REGION} --name ${CLUSTER_NAME}

# Delete Helm releases to remove services with LoadBalancer type
echo "Removing Helm releases..."
# Check if we can connect to the cluster first
if kubectl get nodes &>/dev/null; then
  helm uninstall apache-web-server 2>/dev/null || echo "apache-web-server release not found or already removed"
  helm uninstall monitoring -n monitoring 2>/dev/null || echo "monitoring release not found or already removed"
  helm uninstall adot-collector -n adot 2>/dev/null || echo "adot-collector release not found or already removed"
else
  echo "Warning: Cannot connect to Kubernetes cluster. Skipping Helm uninstall steps."
fi

# Only proceed with load balancer cleanup if we can connect to the cluster
if kubectl get nodes &>/dev/null; then
  # Wait for load balancers to be deleted
  echo "Waiting for load balancers to be deleted..."
  sleep 30

  # List any remaining load balancers
  echo "Checking for remaining load balancers..."
  kubectl get svc --all-namespaces | grep LoadBalancer || echo "No LoadBalancer services found."

  # Delete any remaining load balancer services manually
  echo "Deleting any remaining LoadBalancer services..."
  SERVICES=$(kubectl get svc --all-namespaces -o json | jq -r '.items[] | select(.spec.type == "LoadBalancer") | .metadata.namespace + "/" + .metadata.name' 2>/dev/null)
  if [ -n "$SERVICES" ]; then
    echo "$SERVICES" | while read -r service; do
      echo "Deleting service $service"
      namespace=$(echo "$service" | cut -d "/" -f1)
      name=$(echo "$service" | cut -d "/" -f2)
      kubectl delete svc -n "$namespace" "$name"
    done
  else
    echo "No LoadBalancer services to delete."
  fi
else
  echo "Warning: Cannot connect to Kubernetes cluster. Skipping load balancer cleanup."
fi

# Final message
echo "\nCleanup process completed."
if kubectl get nodes &>/dev/null; then
  echo "Kubernetes cluster is still accessible. You can now run 'terraform destroy'."
else
  echo "Kubernetes cluster is not accessible. This could be because:"
  echo "  - The cluster has already been destroyed"
  echo "  - There are authentication issues with the cluster"
  echo "  - The AWS CLI is not properly configured"
  echo "\nYou can proceed with 'terraform destroy' if needed."
fi