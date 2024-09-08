resource "yandex_vpc_network" "network-main" {
  name = var.network_name
}

resource "yandex_vpc_subnet" "mysubnet-a" {
  v4_cidr_blocks = var.vpc_resources.vpc_zone_a.v4_cidr_blocks
  zone           = var.vpc_resources.vpc_zone_a.zone
  network_id     = yandex_vpc_network.network-main.id
  route_table_id = yandex_vpc_route_table.rt.id
}

resource "yandex_vpc_subnet" "mysubnet-b" {
  v4_cidr_blocks = var.vpc_resources.vpc_zone_b.v4_cidr_blocks
  zone           = var.vpc_resources.vpc_zone_b.zone
  network_id     = yandex_vpc_network.network-main.id
  route_table_id = yandex_vpc_route_table.rt.id
}

resource "yandex_vpc_subnet" "mysubnet-d" {
  v4_cidr_blocks = var.vpc_resources.vpc_zone_d.v4_cidr_blocks
  zone           = var.vpc_resources.vpc_zone_d.zone
  network_id     = yandex_vpc_network.network-main.id
  route_table_id = yandex_vpc_route_table.rt.id
}

resource "yandex_vpc_gateway" "nat_gateway" {
  name = "test-gateway"
  shared_egress_gateway {}
}
resource "yandex_vpc_route_table" "rt" {
  network_id     = yandex_vpc_network.network-main.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}
