provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_artifact_registry_repository" "test_repo" {
  provider      = google
  location      = var.region
  repository_id = "test-repo"
  description   = "Test Docker Repository"
  format        = "DOCKER"
}