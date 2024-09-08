resource "local_file" "inventory_cfg" {
  content = templatefile("${path.module}/inventory.tftpl",
    { 
    master  =  [yandex_compute_instance.master],
    worker1 =  [yandex_compute_instance.worker-1],
    worker2 =  [yandex_compute_instance.worker-2],
    docker = [yandex_compute_instance.docker],
    registry = [yandex_container_registry.my-reg]
    }  
)

  filename = "${abspath(path.module)}/inventory"
}


resource "null_resource" "web_hosts_provision" {
#Ждем создания инстанса
depends_on = [yandex_compute_instance.master, local_file.inventory_cfg]


#Добавление ПРИВАТНОГО ssh ключа в ssh-agent

#  provisioner "local-exec" {
#    command = "cat ~/.ssh/id_ed25519 | ssh-add -"
#  }

#Костыль!!! Даем ВМ 60 сек на первый запуск. Лучше выполнить это через wait_for port 22 на стороне ansible
 # В случае использования cloud-init может потребоваться еще больше времени
  provisioner "local-exec" {
    command = "sleep 60"
  }

#Запуск ansible-playbook
  provisioner "local-exec" {                  
     command  = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -i ${abspath(path.module)}/inventory ${abspath(path.module)}/ansible/kubernetes_install.yml"
     environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
     #срабатывание триггера при изменении переменных
  }
    triggers = {  
#всегда т.к. дата и время постоянно изменяются
      always_run         = "${timestamp()}" 
 # при изменении содержимого playbook файла
      playbook_src_hash  = file("${abspath(path.module)}/ansible/kubernetes_install.yml") 
      ssh_public_key     = file("${abspath(path.module)}/secret/id_ed25519.pub") # при изменении переменной
    }
  
  
  connection {
        type     = "ssh"
        user     = "ubuntu"
        private_key = file("${abspath(path.module)}/secret/id_ed25519")
        host = yandex_compute_instance.master.network_interface.0.nat_ip_address
    }
  provisioner "remote-exec" {
    inline = [
      "cd /home/ubuntu/kubespray",
      "ansible-playbook -i inventory/mycluster/hosts.yaml cluster.yml -b -v",
      "mkdir ~/.kube",
      "sudo cp /etc/kubernetes/admin.conf ~/.kube/config",
      "sudo chown ubuntu:ubuntu ~/.kube/config"
    ]
  }
#Запуск ansible-playbook
  provisioner "local-exec" {                  
    command  = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook --vault-id @prompt -i ${abspath(path.module)}/inventory ${abspath(path.module)}/ansible/docker_install.yml"
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
     #срабатывание триггера при изменении переменных
   }
   provisioner "local-exec" {                  
     command  = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -i ${abspath(path.module)}/inventory ${abspath(path.module)}/ansible/kubernetes_monitoring.yml"
     environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
     #срабатывание триггера при изменении переменных
   }
}