locals{
    ssh_metadata = {
      serial-port-enable = 1
      ssh-keys  = "ubuntu:${file("~/.ssh/id_ed25519.pub")} " 
    }
 }

locals {
    name_vm_m = "${ var.name }-${ var.master }"
    name_vm_w1 = "${ var.name }-${ var.worker1 }"
    name_vm_w2 = "${ var.name }-${ var.worker2 }"
    name_vm_d  = "${ var.name }-${ var.docker }"
}
