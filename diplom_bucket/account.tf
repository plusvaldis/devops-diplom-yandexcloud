// Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "diplom-cherepanov-static-key" {
  service_account_id = var.service_account_id
  description        = "static access key for object storage"
}
