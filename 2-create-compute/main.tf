provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_instance" "test_compute" {
  name         = "test-compute"
  machine_type = "e2-micro"
  zone         = var.zone

  tags = ["http-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update -y
    apt-get install -y nginx
  EOT
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

output "test_compute_external_ip" {
  description = "Ephemeral public IP of the VM"
  value       = google_compute_instance.test_compute.network_interface[0].access_config[0].nat_ip
}