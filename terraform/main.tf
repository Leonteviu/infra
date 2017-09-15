provider "google" {
  ### project = "infra-179710"
  ### region = "europe-west1"
  project = "${var.project}"

  region = "${var.region}"
}

resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "europe-west1-b"
  tags         = ["reddit-app"]

  metadata {
    ### sshKeys = "appuser:${file("~/.ssh/appuser.pub")}"
    sshKeys = "appuser:${file(var.public_key_path)}"
  }

  connection {
    type  = "ssh"
    user  = "appuser"
    agent = false

    ### private_key = "${file("~/.ssh/appuser")}"
    private_key = "${file(var.private_key)}"
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }

  # BOOT DISK
  boot_disk {
    initialize_params {
      ### image = "reddit-base-1505214895"
      image = "${var.disk_image}"
    }
  }

  # NETWORK INTERFACE
  network_interface {
    # NET to Connect
    network = "default"

    # Use ephemeral IP to connect from Internet
    ###    access_config {}
    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["reddit-app"]
}

resource "google_compute_firewall" "firewall_ssh" {
  name        = "default-allow-ssh"
  network     = "default"
  description = "Allow SSH from all hosts"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}
