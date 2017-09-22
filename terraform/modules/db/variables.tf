variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}

variable target_tags {
  description = "порт будет доступен только для инстансов с тегом ..."
  default     = ["reddit-db"]
}

variable source_tags {
  description = "правило применимо к инстансам с тегом ..."
  default     = ["reddit-app"]
}

variable firewall_mongo_port {
  description = "Firewall port access to MongoDB"
  default     = ["27017"]
}
