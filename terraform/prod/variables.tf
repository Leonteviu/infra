variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable disk_image {
  description = "Disk image"
}

variable private_key {
  description = "Path to the private key used for ssh access"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base-create-with-ansible-role"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base-create-with-ansible-role"
}

variable source_ranges {
  description = "Allowed IP addresses"
  default     = ["185.13.112.123/32"]
}
