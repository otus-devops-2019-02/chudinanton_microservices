provider "google" {
  # Версия провайдера
  version = "2.0.0"

  # ID проекта
  project = "${var.project}"
  region  = "${var.region}"
}

module "vpc" {
  source        = "modules/vpc"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["gitlab"]
}

module "gitlab" {
  source           = "modules/gitlab"
  zone             = "${var.zone}"
  disk_image            = "${var.disk_image}"
  public_key_path  = "${var.public_key_path}"
  private_key_path = "${var.private_key_path}"
}
