data "yandex_compute_image" "ubuntu-2004-lts" {
  family = var.image
}

resource "yandex_compute_instance" "kubernetes-vm" {


  for_each = { for vm in local.vms_bav: "${vm.vm_name}" => vm }
  name = each.key
  platform_id = each.value.platform
  resources {
        cores           = each.value.cpu
        memory          = each.value.ram
        core_fraction = each.value.frac
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      size     = each.value.disk
    }
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.'${each.value.zone}'.id}"
    nat       = each.value.nat
  }

  metadata = local.ssh_metadata
  
}
