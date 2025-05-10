terraform {
  backend "gcs" {
    bucket = "flask-app-devops-task-tfstate"
    prefix = "terraform/state"
  }
}