output "public_ips_master" {
  value = data.azurerm_public_ip.this.ip_address
}
