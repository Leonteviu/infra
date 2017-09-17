variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable source_ranges {
  description = "Allowed IP addresses"
  default     = ["0.0.0.0/0"]
}

variable target_tags {
  description = "будет доступен только для инстансов с тегом ..."
  default     = ["reddit-app"]
}

variable firewall_puma_port {
  description = "Firewall port access to Puma"
  default     = ["9292"]
}
