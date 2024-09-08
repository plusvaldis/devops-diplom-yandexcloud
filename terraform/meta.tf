#cloud-config
users:
  - name: cherepanov
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
     - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtbBcC5s4UOEuZjXxnA4eG73UEHLASad8pszGZ+QiJJ pc@pc-MS-7D15