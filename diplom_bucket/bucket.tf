// Создание бакета с использованием ключа
resource "yandex_storage_bucket" "storage" {
  access_key            = yandex_iam_service_account_static_access_key.diplom-cherepanov-static-key.access_key
  secret_key            = yandex_iam_service_account_static_access_key.diplom-cherepanov-static-key.secret_key
  bucket                = "netologybucket"
  max_size              = 1056784
  default_storage_class = "standard"
  anonymous_access_flags {
    read        = false
    list        = false
    config_read = false
  }
}
