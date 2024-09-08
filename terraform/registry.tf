resource "yandex_container_registry" "my-reg" {
  name = "registry-diplom-dev"
  folder_id = var.folder_id
}