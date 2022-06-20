#Definition
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.25.0"
    }
  }
}

#Initialization
provider "google" {
  # Configuration options
  credentials = file("./CREDENTIALS_FILE.json")
  project = "fluted-ranger-351208"
  region = "us-central1 (Iowa)"
  zone         = "us-central1-c"
}

#Resource Definition

resource "google_compute_instance" "tf-ip3-server" {
  name         = "tf-ip3-server"
  machine_type = "f1-micro"
 

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  // Local SSD disk
#   scratch_disk {
#     interface = "SCSI"
#   }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"
}