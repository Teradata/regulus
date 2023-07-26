output "public_ip_workspaces" {
  value = data.azurerm_public_ip.this.ip_address
}

output "http_access_workspaces" {
  value = "http://${data.azurerm_public_ip.this.ip_address}:${var.http_port}"
}

output "grpc_access_from_public" {
  value = "${data.azurerm_public_ip.this.ip_address}:${var.grpc_port}"
}

output "grpc_access_from_private" {
  value = "${azurerm_network_interface.this.private_ip_address}:${var.grpc_port}"
}
