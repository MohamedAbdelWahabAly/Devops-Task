# resource "google_storage_bucket" "flask_app_gcs_bucket" {
#   name          = "flask-app-devops-task-tfstate"
#   project       = var.project_id
#   location      = "EU"
#   force_destroy = true

#   uniform_bucket_level_access = true

# #   labels = {
# #     env = "development"
# #   }

#   versioning {
#     enabled = false
#   }

# }