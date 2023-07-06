terraform {

  # override at init if needed
  backend "local" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "<=3.50.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "<=2.2.0"
    }
  }
}

provider "azurerm" {
  features {
    virtual_machine {
      delete_os_disk_on_deletion = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = false
    }
  }
}


resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.region
}

resource "azurerm_virtual_network" "this" {
  name                = var.network_name
  address_space       = [var.network_cidr]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  lifecycle {
    ignore_changes = [
      tags["CreateDate"],
      tags["Owner"]
    ]
  }
}

resource "azurerm_subnet" "this" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_cidr]
}

output "resource_group" {
  value = azurerm_resource_group.this
}

output "network" {
  value = azurerm_virtual_network.this
}

output "subnet" {
  value = azurerm_subnet.this
}
