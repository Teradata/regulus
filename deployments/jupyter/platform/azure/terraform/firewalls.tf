resource "azurerm_network_security_group" "this" {
  name                = join("-", [var.jupyter_name, "access"])
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  tags                = var.tags
}

resource "azurerm_network_security_rule" "ssh" {
  name                         = "${local.ssh_enabled}_SSH"
  description                  = "${local.ssh_enabled} SSH"
  priority                     = 700
  direction                    = "Inbound"
  access                       = local.ssh_enabled
  protocol                     = "Tcp"
  source_port_range            = "*"
  destination_port_range       = "22"
  source_address_prefixes      = var.access_cidrs
  destination_address_prefixes = var.egress_cidrs
  resource_group_name          = data.azurerm_resource_group.this.name
  network_security_group_name  = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "http" {
  name                         = "Allow_HTTP"
  description                  = "Allow HTTP"
  priority                     = 701
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "Tcp"
  source_port_range            = "*"
  destination_port_range       = var.http_port
  source_address_prefixes      = var.access_cidrs
  destination_address_prefixes = var.egress_cidrs
  resource_group_name          = data.azurerm_resource_group.this.name
  network_security_group_name  = azurerm_network_security_group.this.name
}
