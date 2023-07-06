output "public_ip" {
  value = data.azurerm_public_ip.this.ip_address
}

output "private_ip" {
  value = azurerm_network_interface.this.private_ip_address
}

output "public_http_access" {
  value = "http://${data.azurerm_public_ip.this.ip_address}:${var.http_port}?token=${random_uuid.jupyter_token.result}"
}

output "private_grpc_access" {
  value = "http://${azurerm_network_interface.this.private_ip_address}:${var.http_port}?token=${random_uuid.jupyter_token.result}"
}

output "security_group" {
  value = azurerm_network_security_group.this.id
}

output "ssh_connection" {
  value = "ssh ec2-user@${data.azurerm_public_ip.this.ip_address}"
}
