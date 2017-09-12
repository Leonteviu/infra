provider "google" {
project = "infra-179710"
region = "europe-west1"
}
resource "google_compute_instance" "app" {
name = "reddit-app"
machine_type = "g1-small"
zone = "europe-west1-b"
metadata {
sshKeys = "appuser:${file("~/.ssh/appuser.pub")}"
}
# BOOT DISK
boot_disk {
initialize_params {
image = "reddit-base-1505214895"
}
}
# NETWORK INTERFACE
network_interface {
# NET to Connect
network = "default"
# Use ephemeral IP to connect from Internet
access_config {}
}
}
resource "google_compute_firewall" "firewall_puma" {
name = "allow-puma-default"
network = "default"
allow {
protocol = "tcp"
ports = ["9292"]
}
source_ranges = ["0.0.0.0/0"]
target_tags = ["reddit-app"]
}

