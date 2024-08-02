// Создание сервисного аккаунта
#resource "yandex_iam_service_account" "diplom-cherepanov" {
#  name = var.ac_name
#  folder_id = var.folder_id
#}

// Назначение роли сервисному аккаунту
#resource "yandex_resourcemanager_folder_iam_member" "diplom-cherepanov-editor" {
#  folder_id = var.folder_id
#  role      = var.ac_role
#  member    = "serviceAccount:${yandex_iam_service_account.diplom-cherepanov.id}"
#}

// Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "diplom-cherepanov-static-key" {
  service_account_id = var.service_account_id
  description        = "static access key for object storage"
}