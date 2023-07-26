output "public_ip_workspaces" {
  value = data.azurerm_public_ip.this.ip_address
}

output "private_ip_workspaces" {
  value = azurerm_network_interface.this.private_ip_address
}

output "private_http_access_workspaces" {
  value = "http://${azurerm_network_interface.this.private_ip_address}:${var.http_port}"
}

output "public_http_access_workspaces" {
  value = "http://${data.azurerm_public_ip.this.ip_address}:${var.http_port}"
}

output "private_grpc_access_workspaces" {
  value = "${azurerm_network_interface.this.private_ip_address}:${var.grpc_port}"
}

output "public_grpc_access_workspaces" {
  value = "${data.azurerm_public_ip.this.ip_address}:${var.grpc_port}"
}

output "security_group" {
  value = azurerm_network_security_group.this.id
}

output "ssh_connection" {
  value = "ssh azureuser@${data.azurerm_public_ip.this.ip_address}"
}
