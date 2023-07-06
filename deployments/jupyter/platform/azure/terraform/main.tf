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
  }
}
