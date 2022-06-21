locals {
  project_id     = "fluted-ranger-351208"
  network        = "default"
  image          = "debian-cloud/debian-11"
  ssh_user       = "root@srv001"
  private_key_path = "/root/.ssh/ansible_ed25519"
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


# Define the port to be exposed
resource "google_compute_firewall" "web" {
  name = "web-access"
  network = local.network

  allow {
    protocol = "tcp"
    ports = ["3000"]
  }

  source_ranges          = [ "0.0.0.0/0" ]
  target_service_accounts = [ "ip3-447@fluted-ranger-351208.iam.gserviceaccount.com" ]
}


#Resource Definition

resource "google_compute_instance" "ip3_machines" {
   count = length(var.new_machines)
  name         = var.new_machines[count.index]
  machine_type = "e2-medium"
 
  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = local.image
    }
  }
provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      # private_key = file(local.private_key_path)
      #host        = google_compute_instance.ip3_machines[count.index].network_interface.0.access_config.0.nat_ip
      host        = google_compute_instance.ip3_machines[0].network_interface.0.access_config.0.nat_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook  -i ${google_compute_instance.ip3_machines[0].network_interface.0.access_config.0.nat_ip}, --private-key ${local.private_key_path} ansible.yml"
    }

  // Local SSD disk
#   scratch_disk {
#     interface = "SCSI"
#   }

  network_interface {
    network = local.network

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"
}





# provisioner "local-exec" {
#   command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u {var.user} -i '${self.ipv4_address},' --private-key ${var.ssh_private_key} playbook.yml"
#   }