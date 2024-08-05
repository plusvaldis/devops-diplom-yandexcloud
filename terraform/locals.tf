locals{
    ssh_metadata = {
      serial-port-enable = 1
      ssh-keys  = "ubuntu:${file("~/.ssh/id_ed25519.pub")} " 
    }
    vms_bav = [
        {
        vm_name = "master"
        cpu     = 4
        ram     = 4
        frac    = 20
        disk    = 20
        nat     = "true"
        platform = "standard-v1"
        zone = "subnet-a"
        },
        {
        vm_name = "worker-1"
        cpu     = 4
        ram     = 8
        frac    = 5
        disk    = 20
        nat     = "true"
        platform = "standard-v1"
        zone = "subnet-b"
        },
        {
        vm_name = "worker-2"
        cpu     = 4
        ram     = 8
        frac    = 5
        disk    = 20
        nat     = "true"
        platform = "standard-v1"
        zone = "subnet-d"
        }
    ]
    subnet_ids = toset([
      "subnet-a",
      "subnet-b",
      "subnet-d",
    ])
}