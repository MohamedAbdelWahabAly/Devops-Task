resource "google_compute_global_address" "flask_app_address" {
	project = var.project_id
	name    = "flask-app-ip"
}
