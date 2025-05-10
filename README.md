# Flask Application with GCP Infrastructure

A containerized Flask application deployed on Google Cloud Platform using Infrastructure as Code (Terraform) and automated CI/CD pipelines.

## Project Overview

This project demonstrates:
- Containerized Python application using Docker
- Infrastructure as Code using Terraform
- Automated CI/CD with GitHub Actions
- GCP services integration (GKE, Artifact Registry, Secret Manager)
- Security best practices (Workload Identity, private clusters).

## Project Structure
```
.
├── Dockerfile              # Multi-stage Docker build
├── app/                    # Flask application
├── Infra/                  # Infrastructure as Code
│   └── terraform/
│       └── dev/           # Development environment
├── .github/               # CI/CD workflows
└── README.md
```

## Detailed Implementation Steps

### 1. Local Development Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd Devops-Task
```

2. Build and test Docker image locally:
```bash
# Build image
docker build -t flask-app .
    
# Run container
docker run -d -p 5000:5000 flask-app

# Test application
curl localhost:5000/user
```

### 2. GCP Project Setup

1. Create a new GCP project:
```bash
gcloud projects create flask-app-devops-task
gcloud config set project flask-app-devops-task
```

2. Configure authentication:
```bash
# Login to GCP
gcloud auth login

# Set up application default credentials
gcloud auth application-default login
```

### 3. Infrastructure Deployment

1. Initialize Terraform:
```bash
cd Infra/terraform/dev
terraform init
```

2. Apply infrastructure:
```bash
# Review changes
terraform plan

# Apply changes
terraform apply
```

This will create:
- VPC network
- GKE cluster
- Artifact Registry
- Secret Manager
- Service accounts

### 4. Container Registry Setup

1. Configure Docker for GCP:
```bash
gcloud auth configure-docker us-central1-docker.pkg.dev
```

2. Push Docker image:
```bash
# Tag image
docker tag flask-app:latest us-central1-docker.pkg.dev/flask-app-devops-task/flask-app/flask-app:latest

# Push image
docker push us-central1-docker.pkg.dev/flask-app-devops-task/flask-app/flask-app:latest
```

### 5. Kubernetes Deployment

1. Get cluster credentials:
```bash
gcloud container clusters get-credentials flask-app --zone us-central1-c
```

2. Deploy application:
```bash
# Set namespace
kubectl config set-context --current --namespace=dev

# Apply manifests
kubectl apply -f Infra/k8s/dev/namespace.yml
kubectl apply -f Infra/k8s/dev/sa.yml
kubectl apply -f Infra/k8s/dev/deployment.yml
kubectl apply -f Infra/k8s/dev/service.yml
kubectl apply -f Infra/k8s/dev/ingress.yml
```

3. Verify deployment:
```bash
# Check pods
kubectl get pods -n dev

# Check services
kubectl get svc -n dev

# Check ingress
kubectl get ingress -n dev
```

### 6. Exposing the Service

1. Get the external IP:
```bash
kubectl get ingress flask-app -n dev -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

2. Update DNS (if using custom domain):
```bash
# Add A record pointing to the external IP
```

3. Test the application:
```bash
curl http://<external-ip>/user
```

