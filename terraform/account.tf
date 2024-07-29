resource "yandex_iam_service_account" "sa" {
  name        = "administrator"
  description = "admin account for terraform"
  folder_id   = var.folder_id
}

