provider "google" {
project = "infra-179710"
region = "europe-west1"
}
resource "google_compute_instance" "app" {
name = "reddit-app"
machine_type = "g1-small"
zone = "europe-west1-b"
tags = ["reddit-app"]
metadata {
sshKeys = "appuser:${file("~/.ssh/appuser.pub")}"
}
connection {
type = "ssh"
user = "appuser"
agent = false
private_key = "${file("~/.ssh/appuser")}"
}
provisioner "file" {
source = "files/puma.service"
destination = "/tmp/puma.service"
}
provisioner "remote-exec" {
script = "files/deploy.sh"
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

