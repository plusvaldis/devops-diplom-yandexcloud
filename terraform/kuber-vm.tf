resource "yandex_compute_instance" "master" {
  name        = local.name_vm_m
  zone        = var.vpc_resources.vpc_zone_a.zone
  platform_id = var.vms_resources.vm_m.platform_version
  resources {
    cores         = var.vms_resources.vm_m.cores
    memory        = var.vms_resources.vm_m.memory
    core_fraction = var.vms_resources.vm_m.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = var.vms_resources.vm_m.size
    }
  }
  scheduling_policy {
    preemptible = var.vms_resources.vm_m.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.mysubnet-a.id
    nat       = var.vms_resources.vm_m.interface_nat
  }

  metadata = local.ssh_metadata
}

resource "yandex_compute_instance" "worker-1" {
  name        = local.name_vm_w1
  zone        = var.vpc_resources.vpc_zone_b.zone
  platform_id = var.vms_resources.vm_w1.platform_version
  resources {
    cores         = var.vms_resources.vm_w1.cores
    memory        = var.vms_resources.vm_w1.memory
    core_fraction = var.vms_resources.vm_w1.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = var.vms_resources.vm_w1.size
    }
  }
  scheduling_policy {
    preemptible = var.vms_resources.vm_w1.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.mysubnet-b.id
    nat       = var.vms_resources.vm_w1.interface_nat
  }

  metadata = local.ssh_metadata
}

resource "yandex_compute_instance" "worker-2" {
  name        = local.name_vm_w2
  platform_id = var.vms_resources.vm_w2.platform_version
  zone        = var.vpc_resources.vpc_zone_d.zone
  resources {
    cores         = var.vms_resources.vm_w2.cores
    memory        = var.vms_resources.vm_w2.memory
    core_fraction = var.vms_resources.vm_w2.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = var.vms_resources.vm_w2.size
    }
  }
  scheduling_policy {
    preemptible = var.vms_resources.vm_w2.preemptible
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.mysubnet-d.id}"
    nat       = var.vms_resources.vm_w2.interface_nat
  }

  metadata = local.ssh_metadata
}