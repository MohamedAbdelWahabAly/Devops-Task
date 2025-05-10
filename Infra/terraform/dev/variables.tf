variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "flask-app-devops-task"
}


variable "region" {
  default = "us-central1"
}

variable "network" {
  description = "The VPC network to host the cluster in"
  type        = string
  default     = "default"
}

#####
# GKE
#####
variable "cluster_name" {
  type    = string
  default = "dev-flask-app"
}
variable "cluster_zone" {
  description = "The zone to host the cluster in"
  type        = string
}
variable "node_machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
  default     = "e2-small"  # 2 vCPU, 2GB memory
}
variable "node_disk_size_gb" {
  description = "Disk size for GKE nodes in GB"
  type        = number
  default     = 30
}
variable "gke_num_nodes" {
  description = "Number of nodes in the GKE cluster"
  type        = number
  default     = 1
}



