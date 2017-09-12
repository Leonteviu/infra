provider "google" {
project = "infra-179710"
region = "europe-west1"
}
resource "google_compute_instance" "app" {
name = "reddit-app"
machine_type = "g1-small"
zone = "europe-west1-b"
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

