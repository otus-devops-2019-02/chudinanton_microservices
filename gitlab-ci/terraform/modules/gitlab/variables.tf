variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}

variable disk_image {
  description = "Disk image"
  default = "ubuntu-1604-lts"
}

variable zone {
  description = "Zone"
  default     = "europe-west3-a"
}
