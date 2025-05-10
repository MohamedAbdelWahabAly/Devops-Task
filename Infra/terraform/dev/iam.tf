############# Work Identity Federation ############

resource "google_iam_workload_identity_pool" "identity_pool" {
  workload_identity_pool_id = "github-gke"
  display_name              = "Github Actions GKE"
  description               = "Identity pool for dev GKE environment"
  disabled                  = false
  project                   = var.project_id
}
resource "google_iam_workload_identity_pool_provider" "identity_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.identity_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "terraform-gcp-oidc-dev"
  display_name                       = "terraform-gcp-oidc-dev"
  description                        = "Terraform GCP OIDC Provider"
  project                            = var.project_id
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.owner"      = "assertion.repository_owner"
    "attribute.ref"        = "assertion.ref"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
  attribute_condition = "assertion.repository == '${local.github_repo}'"

}
resource "google_service_account" "sa-github-actions" {
  display_name = " sa github action"
  account_id   = "sa-github-actions"
  project      = var.project_id
}


resource "google_service_account_iam_member" "workload_identity_user" {
  service_account_id = google_service_account.sa-github-actions.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.identity_pool.name}/attribute.repository/${local.github_repo}"

}
resource "google_project_iam_member" "run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.sa-github-actions.email}"
}
resource "google_project_iam_member" "service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.sa-github-actions.email}"
}
resource "google_project_iam_member" "artifactregistry_admin" {
  project = var.project_id
  role    = "roles/artifactregistry.admin"
  member  = "serviceAccount:${google_service_account.sa-github-actions.email}"
}