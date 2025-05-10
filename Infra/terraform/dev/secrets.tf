# Create a secret for flask app
resource "google_secret_manager_secret" "flask_app_secret" {
  secret_id = "flask-app-secret"
  project   = var.project_id

  replication {
    auto {}
  }

  depends_on = [
    google_project_service.services["secretmanager.googleapis.com"]
  ]
}

