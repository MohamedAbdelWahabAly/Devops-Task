# GKE Cluster with private nodes and workload identity
resource "google_container_cluster" "flask-app" {
  name            = "flask-app"
  project         = var.project_id
  network         = var.network
  subnetwork      = var.network
  location        = var.cluster_zone
  networking_mode = "VPC_NATIVE"

  # Private nodes for better security
  private_cluster_config {
    enable_private_nodes   = true
    master_ipv4_cidr_block = "10.0.0.0/28"
  }

  # Enable workload identity for pod authentication
  # This allows pods to use Google service accounts without key files
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block = ""
  }

  remove_default_node_pool = true
  initial_node_count       = 1
}

# Node Pool with Preemptible VMs
resource "google_container_node_pool" "preemptible_nodes" {

  name       = "preemptible-nodepool"
  project    = var.project_id
  location   = var.cluster_zone
  cluster    = google_container_cluster.flask-app.name
  node_count = var.gke_num_nodes

  node_config {
    preemptible = true
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    machine_type = var.node_machine_type
    disk_size_gb = var.node_disk_size_gb
    tags         = ["gke-node", "${var.project_id}-gke"]
    
    metadata = {
      disable-legacy-endpoints = "true"
    }
    
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
    
    shielded_instance_config {
      enable_integrity_monitoring = true
      enable_secure_boot          = false
    }
  }

  # Auto-repair and upgrade for maintenance
  management {
    auto_repair  = true
    auto_upgrade = true
  }

  # Zero-downtime upgrade settings
  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
    strategy        = "SURGE"
  }

  # Auto-scaling between 1-2 nodes
  autoscaling {
    location_policy      = "BALANCED"
    max_node_count       = 2
    min_node_count       = 1
    total_max_node_count = 0
    total_min_node_count = 0
  }

  lifecycle {
    ignore_changes = [node_count]
  }
}

resource "google_service_account" "cluster_gsa" {
  project      = var.project_id
	account_id   = "flask-app-gke-sa"
	display_name = "Flask App GKE"
}

resource "google_service_account_iam_binding" "cluster_gsa_ksa_binding" {
	service_account_id = google_service_account.cluster_gsa.name
	role               = "roles/iam.workloadIdentityUser"

	members = [
		"serviceAccount:${var.project_id}.svc.id.goog[dev/flask-app]"
	]

	depends_on = [
		google_container_cluster.flask-app
	]
}