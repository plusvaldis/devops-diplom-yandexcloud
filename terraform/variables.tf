//default
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "service_account_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}
//zone
variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "access_key_bucket" {
  type    = string
  default = null
}

variable "secret_key_bucket" {
  type    = string
  default = null
}

variable "secret_key_bucket_S3" {
  type    = string
  default = null
}

variable "token" {
  type    = string
  default = null
}


//storage
variable "ac_role" {
  type        = string
  default     = "storage.editor"
  description = "service account role"
}

variable "ac_name" {
  type        = string
  default     = "terraform-editor"
  description = "admin account for terraform"
}
//network
variable "network_name" {
  type        = string
  default     = "diplom-devops"
}
variable "vpc_resources" {
  type=map(object({
      v4_cidr_blocks = list(string)
      zone = string
  }))
  default = {
    "vpc_zone_a" = {
      v4_cidr_blocks = ["10.5.0.0/16"]
      zone = "ru-central1-a"
    }
    "vpc_zone_b" = {
      v4_cidr_blocks = ["10.6.0.0/16"]
      zone = "ru-central1-b"
    }
    "vpc_zone_d" = {
      v4_cidr_blocks = ["10.7.0.0/16"]
      zone = "ru-central1-d"
    }
  }
}

//image
variable "image" {
  type = string
  default = "ubuntu-2004-lts-oslogin"
  description = "image"
}

//vm-default
variable "name" {
  type=string
  default="netology-develop"
}

//vm-kuber
variable "master" {
  type=string
  default="platform-master"
}
variable "worker1" {
  type=string
  default="platform-worker-1"
}
variable "worker2" {
  type=string
  default="platform-worker-2"
}
variable "docker" {
  type=string
  default="docker"
}
variable "vms_resources" {
  type=map(object({
      cores = number
      memory = number
      core_fraction = number
      platform_version = string
      preemptible = bool
      interface_nat = bool
      size = number
  }))
  default = {
    "vm_m" = {
      cores = 4
      memory = 8
      core_fraction = 20
      platform_version = "standard-v2"
      preemptible = true
      interface_nat = true
      size = 30
    }
    "vm_w1" = {
      cores = 4
      memory = 4
      core_fraction = 20
      platform_version = "standard-v2"
      preemptible = true
      interface_nat = false
      size = 30
    }
    "vm_w2" = {
      cores = 4
      memory = 4
      core_fraction = 20
      platform_version = "standard-v3"
      preemptible = true
      interface_nat = false
      size = 30
    }
    "vm_d" = {
      cores = 2
      memory = 2
      core_fraction = 20
      platform_version = "standard-v3"
      preemptible = true
      interface_nat = true
      size = 30 
    }
  }
}
