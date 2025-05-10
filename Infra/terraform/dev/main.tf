terraform {
  required_version = "1.9.2"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.34.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.cluster_zone
}

# Enable required services
resource "google_project_service" "services" {
  project = var.project_id
  for_each = toset([
    "compute.googleapis.com",           # Required for GKE nodes and networking
    "container.googleapis.com",         # GKE API
    "iam.googleapis.com",              # Required for service accounts
    "cloudresourcemanager.googleapis.com", # Required for IAM
    "serviceusage.googleapis.com",      # Required for enabling services
    "artifactregistry.googleapis.com",  # Required for container registry
    "secretmanager.googleapis.com",     # Required for secrets
    "storage-api.googleapis.com",       # Required for GCS buckets
    "servicenetworking.googleapis.com"  # Required for VPC networking
  ])
  service            = each.value
  disable_on_destroy = false
}


