output "public_ip_jupyter" {
  value = data.azurerm_public_ip.this.ip_address
}

output "http_access_jupyter" {
  value = "http://${data.azurerm_public_ip.this.ip_address}:${var.http_port}?token=${random_uuid.jupyter_token.result}"
}

output "http_access_jupyter" {
  value = "http://${data.azurerm_public_ip.this.ip_address}:${var.http_port}?token=${random_uuid.jupyter_token.result}"
}
