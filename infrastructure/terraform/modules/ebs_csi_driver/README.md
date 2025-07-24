# EBS CSI Driver Module

This Terraform module creates the necessary IAM roles and policies for the AWS EBS CSI (Container Storage Interface) Driver to work with Amazon EKS.

## Overview

The EBS CSI Driver allows Kubernetes to manage the lifecycle of Amazon EBS volumes for persistent storage. This module sets up the required IAM permissions for the EBS CSI Driver to create, attach, detach, and delete EBS volumes on behalf of your Kubernetes pods.

## Resources Created

- IAM Role with OIDC trust relationship for EKS service account
- IAM Policy with permissions for EBS volume management
- Trust relationship configured for the `ebs-csi-controller-sa` service account in the `kube-system` namespace

## Usage

```hcl
module "ebs_csi_driver" {
  source = "./modules/ebs_csi_driver"
  
  project_prefix        = "my-project"
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| `project_prefix` | Project prefix for resource naming | `string` | yes |
| `cluster_oidc_issuer_url` | EKS cluster OIDC issuer URL | `string` | yes |

## Outputs

| Name | Description |
|------|-------------|
| `ebs_csi_role_arn` | IAM role ARN for EBS CSI Driver |

## EBS CSI Driver Installation

After applying this Terraform module, you can install the EBS CSI Driver as an EKS add-on:

```bash
aws eks create-addon \
  --cluster-name <cluster-name> \
  --addon-name aws-ebs-csi-driver \
  --service-account-role-arn $(terraform output -raw ebs_csi_role_arn) \
  --region <region>
```

## Storage Classes

The EBS CSI Driver creates the following storage classes:
- `gp2` (default)
- `gp3`

You can create custom storage classes for specific use cases:

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ebs-sc
provisioner: ebs.csi.aws.com
parameters:
  type: gp3
  encrypted: "true"
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
```

## Persistent Volume Claims

Example PVC using the EBS CSI Driver:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ebs-claim
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: gp3
  resources:
    requests:
      storage: 10Gi
```

## Additional Information

- [AWS EBS CSI Driver GitHub Repository](https://github.com/kubernetes-sigs/aws-ebs-csi-driver)
- [AWS EBS CSI Driver Documentation](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html)