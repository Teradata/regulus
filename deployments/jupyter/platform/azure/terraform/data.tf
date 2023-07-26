data "azurerm_client_config" "this" {}
data "azurerm_subscription" "this" {}

locals {
  image_publisher = "Canonical"
  image_offer     = "0001-com-ubuntu-server-jammy"
  image_sku       = "22_04-lts-gen2"
  ssh_enabled     = var.ssh_enabled ? "Allow" : "Deny"
}

data "azurerm_ssh_public_key" "this" {
  name                = var.key_name
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_platform_image" "this" {
  location  = data.azurerm_resource_group.this.location
  publisher = local.image_publisher
  offer     = local.image_offer
  sku       = local.image_sku
}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "this" {
  name                = var.network_name
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_subnet" "this" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.this.name
  resource_group_name  = data.azurerm_resource_group.this.name
}

data "cloudinit_config" "this" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/templates/cloudinit.yaml.tftpl", {
      jupyter_service : base64encode(templatefile("${path.module}/templates/jupyter.service.tftpl", {
        jupyter_registry : var.jupyter_registry
        jupyter_repository : var.jupyter_repository
        jupyter_version : var.jupyter_version
        jupyter_token : random_uuid.jupyter_token.result
        http_port : var.http_port
      }))
    })
  }
}

data "azurerm_public_ip" "this" {
  name                = azurerm_public_ip.this.name
  resource_group_name = data.azurerm_resource_group.this.name
  depends_on          = [azurerm_virtual_machine.this]
}

