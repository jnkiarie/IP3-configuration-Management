locals {
  project_id     = "fluted-ranger-351208"
  network        = "default"
  image          = "ubuntu-pro-2004-focal-v20220610"
  ssh_user       = "root@srv001"
  private_key_path = "~/.ssh/ansible_ed25519"
}

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
  project = local.project_id
  region  = "us-central1"
  zone    = "us-central1-a"

}

# Define Service Account tp grant permission to apps on your VM
resource "google_service_account" "default" {
  account_id = "113008182886204786185"
}

# Define the port to be exposed
resource "google_compute_firewall" "web" {
  name = "web-access"
  network = local.network

  allow {
    protocol = "tcp"
    ports = ["3000"]
  }

  source_ranges          = [ "0.0.0.0/0" ]
  target_service_accounts = [ "1075600608145-compute@developer.gserviceaccount.com" ]
}


#Resource Definition

resource "google_compute_instance" "ip3_machines" {
   count = length(var.new_machines)
  name         = var.new_machines[count.index]
  machine_type = "e2-medium"

  named_port {
    name = "http"
    port = 3000
  }
 
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

provisioner "local-exec" {
  command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u {var.user} -i '${self.ipv4_address},' --private-key ${var.ssh_private_key} playbook.yml"
  }