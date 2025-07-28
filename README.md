# EKS Apache Web Server Deployment

Complete CI/CD pipeline for deploying Apache web server on Amazon EKS with monitoring.

## 🏗️ Architecture

- **Infrastructure**: ☁️ AWS VPC + EKS cluster
- **Application**: 🌐 Apache web server (Helm chart)
- **Monitoring**: 📊 Prometheus + Grafana stack
- **Observability**: 🔍 AWS Distro for OpenTelemetry (ADOT) collector
- **CI/CD**: ⚙️ CodePipeline + EventBridge automation

## 📋 Prerequisites

- ☁️ AWS CLI configured
- 🏗️ Terraform >= 1.0
- ⚡ kubectl
- ⎈ Helm 3.x

## 🚀 Quick Start

### 1️⃣ Deploy Infrastructure
```bash
terraform init
terraform plan
terraform apply
```

### 2️⃣ Configure kubectl
```bash
aws eks update-kubeconfig --region <region> --name <cluster-name>
```

### 3️⃣ Grant CodeBuild Access to EKS
After creating the EKS cluster, allow the CodeBuild role to interact with it. You’ll need to allow-list the service role associated with the build project(s) by adding the IAM principal to access your Cluster’s aws-auth config-map or using EKS Access Entries (recommended):
```bash
# Create an access entry so the specified IAM role can interact with the EKS cluster
aws eks create-access-entry \
        --cluster-name <cluster-name> \
        --principal-arn <codebuild_role_arn> \
        --region <region> || echo "Access entry might already exist"
        
# Associate the IAM role with an EKS access policy        
aws eks associate-access-policy \
          --cluster-name <cluster-name> \
          --principal-arn <codebuild_role_arn> \
          --policy-arn arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy \
          --access-scope type=cluster \
          --region <region> || echo "Access policy might already be attached"
```

### 4️⃣ Deploy Applications
```bash
# Install EBS CSI Driver
aws eks create-addon \
  --cluster-name <cluster-name> \
  --addon-name aws-ebs-csi-driver \
  --service-account-role-arn $(terraform output -raw csi_driver_role_arn) \
  --region <region>

# Deploy monitoring stack
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  -f helm_charts/monitoring-values.yaml --timeout 10m

# Deploy ADOT RBAC
kubectl apply -f k8s-rbac/adot-rbac.yaml

# Deploy ADOT collector
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm upgrade --install adot-collector open-telemetry/opentelemetry-collector \
  --namespace adot --create-namespace \
  -f helm_charts/adot-values.yaml

# Deploy Apache web server
helm upgrade --install apache-web-server helm_charts/apache-web-server
```

## 🧩 Components

### 🏗️ Infrastructure (Terraform)
- **vpc.tf**: VPC with public/private subnets
- **eks_cluster.tf**: EKS cluster with managed node groups
- **eventbridge.tf**: CI/CD automation for main branch pushes
- **csi_driver.tf**: EBS CSI driver IAM role and policy

### 📦 Application (Helm)
- **apache-web-server/**: Custom Helm chart
  - Configurable replicas, resources
  - LoadBalancer service
  - ServiceMonitor for Prometheus

### 📊 Monitoring
- **Prometheus**: Metrics collection with 30-day retention
- **Grafana**: Visualization with pre-configured dashboards
- **AlertManager**: Alert routing and notifications
- **ADOT Collector**: AWS Distro for OpenTelemetry metrics collection
- **CloudWatch**: AWS native metrics storage and monitoring

## 🔗 Access Services

### 📊 Grafana Dashboard
```bash
kubectl port-forward -n monitoring svc/monitoring-grafana 3000:80
```
- URL: http://localhost:3000
- Username: admin
- Password: admin123

### 🔍 Prometheus
```bash
kubectl port-forward -n monitoring svc/monitoring-kube-prometheus-prometheus 9090:9090
```
- URL: http://localhost:9090

### 🌐 Apache Web Server
```bash
# Get the LoadBalancer external IP/hostname
kubectl get svc apache-web-server-service

# Or use port-forwarding for local access
kubectl port-forward svc/apache-web-server-service 8080:80
```

Access via LoadBalancer external IP/hostname in your browser: http://<EXTERNAL-IP>
Or if using port-forwarding: http://localhost:8080

### ☁️ CloudWatch Metrics
- Navigate to AWS CloudWatch Console
- Check `EKS/Apache` namespace for custom metrics
- View container insights for cluster metrics

## 📈 Pre-configured Dashboards

- **Kubernetes Cluster Overview**
- **Kubernetes Pods**
- **Node Exporter**
- **Kubernetes Deployments**
- **Kubernetes Ingress**
- **Apache Overview**

### 🌐 Apache Dashboard

The Apache Overview dashboard provides comprehensive monitoring of your Apache web server instances:

**Key Metrics:**
- **Server Status**: Uptime, workers, and requests per second
- **Traffic**: Bytes sent/received and request volume
- **Performance**: CPU usage, memory consumption, and response times
- **Errors**: HTTP status codes (4xx/5xx errors)
- **Worker Processes**: Busy vs. idle workers

This dashboard helps you monitor Apache performance, identify bottlenecks, and troubleshoot issues in real-time. All metrics are collected via the Apache exporter which transforms Apache's server-status data into Prometheus-compatible metrics.

## 🔄 CI/CD Pipeline

### ⚡ Trigger
- Automatic deployment on push to `main` branch
- EventBridge monitors GitHub repository events

### 📝 Pipeline Steps
1. Install Helm
2. Install EBS CSI Driver
3. Add Prometheus Helm repository
4. Deploy monitoring stack
5. Deploy Apache application
6. Verify deployments

### ⚙️ Configuration
- **deployspec.yml**: CodeBuild specification
- **monitoring-values.yaml**: Prometheus/Grafana configuration
- **apache-web-server/values.yaml**: Application configuration

### 🔗 GitHub Connection Setup

Before the CI/CD pipeline can access your GitHub repository, you need to authorize the connection:

1. Go to AWS Console → Developer Tools → Settings → Connections
2. Find the connection named "eks-apache-github-connection" (it will be in "Pending" status)
3. Click on the connection
4. Click "Update pending connection"
5. Click "Install a new app" if prompted
6. Authorize "AWS Connector for GitHub by Amazon Web Services"
7. Select the repository you want to connect to
8. Click "Connect"

After completing these steps, your pipeline will be able to access your GitHub repository and will automatically trigger on pushes to the main branch.

## 🎛️ Customization

### 📈 Scaling Apache
Edit `helm_charts/apache-web-server/values.yaml`:
```yaml
replicaCount: 5
resources:
  requests:
    cpu: "500m"
    memory: "128Mi"
```

### 💾 Monitoring Retention
Edit `helm_charts/monitoring-values.yaml`:
```yaml
prometheus:
  prometheusSpec:
    retention: 60d
    storageSpec:
      volumeClaimTemplate:
        spec:
          resources:
            requests:
              storage: 100Gi
```

## 🔧 Troubleshooting

### 🔍 Check Pod Status
```bash
kubectl get pods -A
```

### 📋 View Logs
```bash
kubectl logs -n monitoring deployment/monitoring-grafana
kubectl logs deployment/apache-web-server
```

### ⎈ Helm Status
```bash
helm list -A
helm status monitoring -n monitoring
helm status apache-web-server
```

## 🧹 Cleanup

```bash
# Use the cleanup script to remove all LoadBalancer services before terraform destroy
./cleanup.sh

# After cleanup script completes successfully
terraform destroy
```

The cleanup script will:
1. Automatically get cluster name and region from Terraform outputs
2. Remove Helm releases that create LoadBalancer services
3. Wait for AWS load balancers to be deleted
4. Delete any remaining LoadBalancer services

This ensures that all AWS resources are properly removed before running `terraform destroy`.

## 🔍 ADOT Configuration

### 🔐 IAM Requirements
- OIDC provider for EKS cluster
- IAM role with `AmazonPrometheusRemoteWriteAccess` policy
- Service account annotation for IAM role assumption

### 🛡️ Kubernetes RBAC
- ClusterRole for API access (nodes, pods, services)
- ClusterRoleBinding to ADOT service account
- Permissions for metrics endpoint access

### 📊 Metrics Export
- **Prometheus**: Local cluster storage via remote write
- **CloudWatch**: AWS native metrics in `EKS/Apache` namespace
- **Dual export**: Enables both Grafana dashboards and CloudWatch alarms

### 🔍 Using OpenTelemetry

#### 👀 Viewing ADOT Collector Status
```bash
# Check ADOT collector pods
kubectl get pods -n adot

# View ADOT collector logs
kubectl logs -n adot deployment/adot-collector-opentelemetry-collector

# Check ADOT collector metrics endpoint
kubectl port-forward -n adot svc/adot-collector-opentelemetry-collector 8888:8888
# Then access http://localhost:8888/metrics in your browser
```

#### 📊 Accessing Collected Metrics
- **In Prometheus**: Query metrics with `apache_` prefix
- **In CloudWatch**: Navigate to CloudWatch console → Metrics → Custom namespaces → EKS/Apache
- **In Grafana**: Use the pre-configured Apache Overview dashboard (3894)

## 🔒 Security Notes

- Change default Grafana password in production
- Configure proper RBAC for services
- Use secrets for sensitive configurations
- Enable network policies for pod isolation
- Review ADOT collector permissions regularly