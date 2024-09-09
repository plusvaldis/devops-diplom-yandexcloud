terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = "netologybucket"
    region = var.default_zone
    key    = var.secret_key_bucket_S3
    access_key = var.access_key_bucket
    secret_key = var.secret_key_bucket
    

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # This option is required for Terraform 1.6.1 or higher.
    skip_s3_checksum            = true # This option is required to describe backend for Terraform version 1.6.3 or higher.
  }
}


provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}
