provider "google" {
  project = var.projectid
  region = var.region
}

resource "google_compute_instance" "default" {
  count        = var.vmnos
  name         = "${var.vmname}-${count.index + 1}"
  machine_type = var.machinetype
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = var.image
    }
  }
  network_interface {
    network = "default"
    access_config {
      // Include this section to give the VM an external ip address
    }
  }
  metadata_startup_script = ""
  // Apply the firewall rule to allow external IPs to access this instance
  tags = ["http-server"]
  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }
}