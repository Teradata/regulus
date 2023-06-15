Permissions Required for 

# ------ wide ------

resource "azurerm_role_definition" "this" {
  name        = "test-for-permissions-issue"
  scope       = data.azurerm_subscription.this.id
  description = "testing permissions issue encountered on azure"
  permissions {
    actions = [
      "Microsoft.Compute/disks/read",
      "Microsoft.Compute/disks/write",
      "Microsoft.Compute/disks/delete",
      "Microsoft.Compute/sshPublicKeys/read",
      "Microsoft.Compute/sshPublicKeys/write",
      "Microsoft.Compute/sshPublicKeys/delete",
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.Compute/virtualMachines/write",
      "Microsoft.Compute/virtualMachines/delete",
      "Microsoft.KeyVault/vaults/read",
      "Microsoft.KeyVault/vaults/write",
      "Microsoft.KeyVault/vaults/delete",
      "Microsoft.KeyVault/vaults/accessPolicies/write",
      "Microsoft.KeyVault/locations/operationResults/read",
      "Microsoft.KeyVault/locations/deletedVaults/purge/action",
      "Microsoft.Network/virtualNetworks/read",
      "Microsoft.Network/virtualNetworks/write",
      "Microsoft.Network/virtualNetworks/delete",
      "Microsoft.Network/virtualNetworks/subnets/read",
      "Microsoft.Network/virtualNetworks/subnets/write",
      "Microsoft.Network/virtualNetworks/subnets/delete",
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/networkInterfaces/read",
      "Microsoft.Network/networkInterfaces/write",
      "Microsoft.Network/networkInterfaces/delete",
      "Microsoft.Network/networkInterfaces/join/action",
      "Microsoft.Network/networkSecurityGroups/read",
      "Microsoft.Network/networkSecurityGroups/write",
      "Microsoft.Network/networkSecurityGroups/delete",
      "Microsoft.Network/networkSecurityGroups/securityRules/read",
      "Microsoft.Network/networkSecurityGroups/securityRules/write",
      "Microsoft.Network/networkSecurityGroups/securityRules/delete",
      "Microsoft.Network/networkSecurityGroups/join/action",
      "Microsoft.Network/publicIPAddresses/read",
      "Microsoft.Network/publicIPAddresses/write",
      "Microsoft.Network/publicIPAddresses/join/action",
      "Microsoft.Network/publicIPAddresses/delete",
      "Microsoft.Resources/subscriptions/resourcegroups/read",
      "Microsoft.Resources/subscriptions/resourcegroups/write",
      "Microsoft.Resources/subscriptions/resourcegroups/delete",
    ]
  }
  assignable_scopes = [
    data.azurerm_subscription.this.id
  ]
}

resource "azurerm_role_assignment" "this" {
  scope                = data.azurerm_subscription.this.id #"/subscriptions/4b46d749-f8dc-481d-af40-35dd76b7424d" #/workspaces" # 
  role_definition_name = azurerm_role_definition.this.name
  principal_id         = azurerm_virtual_machine.this.identity.0.principal_id
}



# ------ narrow ------

# resource "azurerm_role_definition" "this" {
#   name        = "test-for-permissions-issue"
#   scope       = "/subscriptions/4b46d749-f8dc-481d-af40-35dd76b7424d"
#   description = "testing permissions issue encountered on azure"
#   permissions {
#     actions = [
#       "Microsoft.Compute/disks/read",
#       "Microsoft.Compute/disks/write",
#       "Microsoft.Compute/disks/delete",
#       "Microsoft.Compute/sshPublicKeys/read",
#       "Microsoft.Compute/sshPublicKeys/write",
#       "Microsoft.Compute/sshPublicKeys/delete",
#       "Microsoft.Compute/virtualMachines/read",
#       "Microsoft.Compute/virtualMachines/write",
#       "Microsoft.Compute/virtualMachines/delete",
#       "Microsoft.KeyVault/vaults/read",
#       "Microsoft.KeyVault/vaults/write",
#       "Microsoft.KeyVault/vaults/delete",
#       "Microsoft.KeyVault/vaults/accessPolicies/write",
#       "Microsoft.KeyVault/locations/operationResults/read",
#       "Microsoft.KeyVault/locations/deletedVaults/purge/action",
#       "Microsoft.Network/virtualNetworks/read",
#       "Microsoft.Network/virtualNetworks/subnets/read",
#       "Microsoft.Network/virtualNetworks/subnets/join/action",
#       "Microsoft.Network/networkInterfaces/read",
#       "Microsoft.Network/networkInterfaces/write",
#       "Microsoft.Network/networkInterfaces/delete",
#       "Microsoft.Network/networkInterfaces/join/action",
#       "Microsoft.Network/networkSecurityGroups/read",
#       "Microsoft.Network/networkSecurityGroups/write",
#       "Microsoft.Network/networkSecurityGroups/delete",
#       "Microsoft.Network/networkSecurityGroups/securityRules/read",
#       "Microsoft.Network/networkSecurityGroups/securityRules/write",
#       "Microsoft.Network/networkSecurityGroups/securityRules/delete",
#       "Microsoft.Network/networkSecurityGroups/join/action",
#       "Microsoft.Network/publicIPAddresses/read",
#       "Microsoft.Network/publicIPAddresses/write",
#       "Microsoft.Network/publicIPAddresses/join/action",
#       "Microsoft.Network/publicIPAddresses/delete",
#       "Microsoft.Resources/subscriptions/resourcegroups/read",

#     ]
#   }
#   assignable_scopes = [
#     "/subscriptions/4b46d749-f8dc-481d-af40-35dd76b7424d/resourceGroups/workspaces-test-qed"
#   ]
# }

# resource "azurerm_role_assignment" "this" {
#   scope       = "/subscriptions/4b46d749-f8dc-481d-af40-35dd76b7424d/resourceGroups/workspaces-test-qed"
#   role_definition_name = azurerm_role_definition.this.name
#   principal_id         = azurerm_virtual_machine.this.identity.0.principal_id
# }