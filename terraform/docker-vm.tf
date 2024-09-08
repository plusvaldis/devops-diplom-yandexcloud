resource "yandex_compute_instance" "docker" {
  name        = local.name_vm_d
  zone        = var.vpc_resources.vpc_zone_a.zone
  platform_id = var.vms_resources.vm_d.platform_version
  resources {
    cores         = var.vms_resources.vm_d.cores
    memory        = var.vms_resources.vm_d.memory
    core_fraction = var.vms_resources.vm_d.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vms_resources.vm_d.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.mysubnet-a.id
    nat       = var.vms_resources.vm_d.interface_nat
  }

  metadata = local.ssh_metadata
}