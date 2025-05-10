resource "google_artifact_registry_repository" "flask_docker_registry" {
  project       = var.project_id
  location      = var.region
  repository_id = "flask-app"
  description   = "Flask docker regisrty"
  format        = "DOCKER"
}
