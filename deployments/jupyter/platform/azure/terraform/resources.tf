resource "azurerm_public_ip" "this" {
  name                = join("-", [var.jupyter_name, "public-ip"])
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  allocation_method   = "Dynamic"
  lifecycle {
    ignore_changes = [
      tags["CreateDate"],
      tags["Owner"]
    ]
  }
}

resource "azurerm_network_interface" "this" {
  name                = join("-", [var.jupyter_name, "nic"])
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  ip_configuration {
    name                          = join("-", [var.jupyter_name, "nic"])
    subnet_id                     = data.azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this.id
  }
  lifecycle {
    ignore_changes = [
      tags["CreateDate"],
      tags["Owner"]
    ]
  }
}

resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_virtual_machine" "this" {
  name                  = var.jupyter_name
  location              = data.azurerm_resource_group.this.location
  resource_group_name   = data.azurerm_resource_group.this.name
  network_interface_ids = [azurerm_network_interface.this.id]
  vm_size               = var.instance_type

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = data.azurerm_platform_image.this.publisher
    offer     = data.azurerm_platform_image.this.offer
    sku       = data.azurerm_platform_image.this.sku
    version   = data.azurerm_platform_image.this.version
  }

  storage_os_disk {
    name              = join("-", [var.jupyter_name, "disk"])
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.disk_type
    disk_size_gb      = var.disk_size
  }

  identity {
    type = "SystemAssigned"
  }

  os_profile {
    computer_name  = var.jupyter_name
    admin_username = "azureuser"
    custom_data    = data.cloudinit_config.this.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = data.azurerm_ssh_public_key.this.public_key
      path     = "/home/azureuser/.ssh/authorized_keys"
    }
  }

  lifecycle {
    ignore_changes = [
      os_profile,
      tags["CreateDate"],
      tags["Owner"]
    ]
  }

  tags = var.tags

  depends_on = [
    azurerm_network_interface_security_group_association.this
  ]
}

resource "azurerm_virtual_machine_extension" "this" {
  name                       = join("-", [var.jupyter_name, "Docker", "Extension"])
  virtual_machine_id         = azurerm_virtual_machine.this.id
  publisher                  = "Microsoft.Azure.Extensions"
  type                       = "DockerExtension"
  type_handler_version       = "1.1"
  auto_upgrade_minor_version = true
  tags                       = var.tags
}

resource "random_uuid" "jupyter_token" {}
