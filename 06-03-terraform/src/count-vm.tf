data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image
}

resource "yandex_compute_instance" "count" {
  count       = 2
  name        = "${var.vm_web_name}-${count.index + 1}"
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vm_web_resources.core
    memory        = var.vm_web_resources.ram
    core_fraction = var.vm_web_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

#   metadata = {
#     user-data = "${file("./meta.yml")}"
#   }

}