# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This project automates the deployment of a single-node Kubernetes cluster on DigitalOcean with TLS-enabled ingress using GitLab CI/CD. The infrastructure includes:

- **Terraform**: Provisions DigitalOcean Kubernetes cluster in FRA1 region
- **Helm Charts**: Deploys ingress-nginx controller, cert-manager, and test application
- **GitLab CI/CD**: Automated deployment pipeline with manual destroy option

## Architecture

The deployment follows this sequence:
1. Terraform creates a 1-node k8s cluster (s-2vcpu-2gb nodes)
2. Helm installs ingress-nginx controller with LoadBalancer service
3. Helm installs cert-manager with CRDs for Let's Encrypt certificates
4. Test application is deployed with TLS-secured ingress at `test.auto.do.t3isp.de`

Domain setup expects wildcard DNS `*.auto.do.t3isp.de` pointing to the LoadBalancer IP.

## Common Commands

### Terraform Operations
```bash
cd terraform
export TF_VAR_do_token=$DIGITALOCEAN_ACCESS_TOKEN
terraform init
terraform apply -auto-approve
terraform output -raw kubeconfig > kubeconfig
terraform destroy -auto-approve  # Manual via CI only
```

### Helm Operations
```bash
export KUBECONFIG=terraform/kubeconfig
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Deploy ingress controller
helm upgrade --install ingress ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  -f helm/ingress/values.yaml

# Deploy cert-manager
helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager --create-namespace \
  -f helm/cert-manager-values.yaml

# Deploy test application
kubectl apply -f helm/testapp/
```

### CI/CD Variables Required
- `DIGITALOCEAN_ACCESS_TOKEN`: DigitalOcean API token
- `GITLAB_PAT_KUBECONFIG`: GitLab Personal Access Token with `api` scope

## File Structure Notes

- `terraform/main.tf`: Core DO k8s cluster resource definition
- `helm/ingress/values.yaml`: Configures nginx-ingress as default ingress class with LoadBalancer
- `helm/cert-manager-values.yaml`: Enables CRD installation
- `helm/testapp/`: Complete k8s manifests for test application with TLS ingress
- `.gitlab-ci.yml`: Three-stage pipeline (deploy, helm, destroy)

The pipeline creates artifacts containing kubeconfig and optionally uploads it as a GitLab CI/CD variable for reuse.