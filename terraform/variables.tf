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