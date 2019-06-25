resource "google_compute_address" "gitlab-ip" {
  name = "ext-gitlab-ip"
}

resource "google_compute_instance" "gitlab" {
  name         = "gitlab-cl"
  machine_type = "n1-standard-1"
  zone         = "${var.zone}"
  tags         = ["gitlab", "docker-machine"]

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
      size  = 60
    }
  }

  # Сеть
  network_interface {
    network = "default"

    access_config {
      nat_ip = "${google_compute_address.gitlab-ip.address}"
    }
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  connection {
    type  = "ssh"
    user  = "appuser"
    agent = false
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    source      = "${path.module}/files/docker-compose.yml"
    destination = "/tmp/docker-compose.yml"
  }

  provisioner "remote-exec" {
    script = "${path.module}/files/docker.sh"
  }

}

resource "google_compute_firewall" "firewall_gitlab" {
  name = "allow-gitlab-default"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "2376"]
  }

  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]

  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["gitlab", "docker-machine"]
}
