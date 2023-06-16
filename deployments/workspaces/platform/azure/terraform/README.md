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
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | <=3.50.0 |
| <a name="requirement_cloudinit"></a> [cloudinit](#requirement\_cloudinit) | <=2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | <=3.50.0 |
| <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit) | <=2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_interface.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.grpc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.http](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.ssh](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine) | resource |
| [azurerm_virtual_machine_extension.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_client_config.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_platform_image.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/platform_image) | data source |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_ssh_public_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/ssh_public_key) | data source |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subscription.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |
| [cloudinit_config.this](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_cidrs"></a> [access\_cidrs](#input\_access\_cidrs) | n/a | `list(string)` | n/a | yes |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | n/a | `number` | `30` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | n/a | `string` | `"Standard_LRS"` | no |
| <a name="input_egress_cidrs"></a> [egress\_cidrs](#input\_egress\_cidrs) | n/a | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_grpc_port"></a> [grpc\_port](#input\_grpc\_port) | n/a | `number` | `3282` | no |
| <a name="input_http_port"></a> [http\_port](#input\_http\_port) | n/a | `number` | `3000` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | `"Standard_B2s"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | n/a | `string` | n/a | yes |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_role_definition_name"></a> [role\_definition\_name](#input\_role\_definition\_name) | n/a | `string` | `null` | no |
| <a name="input_ssh_enabled"></a> [ssh\_enabled](#input\_ssh\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_workspaces_name"></a> [workspaces\_name](#input\_workspaces\_name) | n/a | `string` | `"workspaces"` | no |
| <a name="input_workspaces_registry"></a> [workspaces\_registry](#input\_workspaces\_registry) | n/a | `string` | `"teradata"` | no |
| <a name="input_workspaces_repository"></a> [workspaces\_repository](#input\_workspaces\_repository) | n/a | `string` | `"regulus-workspaces"` | no |
| <a name="input_workspaces_version"></a> [workspaces\_version](#input\_workspaces\_version) | n/a | `string` | `"latest"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_grpc_access_workspaces"></a> [private\_grpc\_access\_workspaces](#output\_private\_grpc\_access\_workspaces) | n/a |
| <a name="output_private_http_access_workspaces"></a> [private\_http\_access\_workspaces](#output\_private\_http\_access\_workspaces) | n/a |
| <a name="output_private_ip_workspaces"></a> [private\_ip\_workspaces](#output\_private\_ip\_workspaces) | n/a |
| <a name="output_public_grpc_access_workspaces"></a> [public\_grpc\_access\_workspaces](#output\_public\_grpc\_access\_workspaces) | n/a |
| <a name="output_public_http_access_workspaces"></a> [public\_http\_access\_workspaces](#output\_public\_http\_access\_workspaces) | n/a |
| <a name="output_public_ip_workspaces"></a> [public\_ip\_workspaces](#output\_public\_ip\_workspaces) | n/a |
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | n/a |
| <a name="output_ssh_connection"></a> [ssh\_connection](#output\_ssh\_connection) | n/a |
<!-- END_TF_DOCS -->