terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)
  project     = "<YOUR_PROJECT_ID>"
  region      = "<YOUR_DESIRED_REGION>"
  zone        = "<YOUR_DESIRED_ZONE>"
}

# GKE Cluster Configurations - Zonal Cluster
resource "google_container_cluster" "gke_cluster" {
  name                     = var.cluster_name
  location                 = "<YOUR_DESIRED_ZONE>"
  remove_default_node_pool = true
  initial_node_count       = 1
  ip_allocation_policy {

  }
  private_cluster_config {
    enable_private_nodes   = true
    master_ipv4_cidr_block = "<YOUR_IPV4_CIDR_BLOCK>"
  }
}

# Node Pool Configurations
resource "google_container_node_pool" "spot_node_pool" {
  name       = "custom-node-pool"
  cluster    = google_container_cluster.gke_cluster.id
  node_count = var.node_count
  node_config {
    spot         = true
    machine_type = "n1-standard-2"
    disk_size_gb = 30
    disk_type    = "pd-standard"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
