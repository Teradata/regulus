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
      workspaces_service : base64encode(templatefile("${path.module}/templates/workspaces.service.tftpl", {
        subscription_id : data.azurerm_subscription.this.subscription_id
        tenant_id : data.azurerm_subscription.this.tenant_id
        workspaces_registry : var.workspaces_registry
        workspaces_repository : var.workspaces_repository
        workspaces_version : var.workspaces_version
        http_port : var.http_port
        grpc_port : var.grpc_port
      }))
    })
  }
}

data "azurerm_public_ip" "this" {
  name                = azurerm_public_ip.this.name
  resource_group_name = data.azurerm_resource_group.this.name
  depends_on          = [azurerm_virtual_machine.this]
}

