targetScope = 'subscription'

@description('name for the resource group and derived network name.')
param name string = 'workspaces'

@description('...')
@allowed(['West US'])
param location string = 'West US'

@description('New network CIDR.')
param networkCidr array = ['10.0.0.0/16']

@description('New subnet CIDR.')
param subnetCidr string = '10.0.0.0/24'

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: name
  location: location
}

module network './modules/network.bicep' = {
  scope: rg
  name: 'networkDeployment'
  params: {
    networkName: name
    networkCidr: networkCidr
    subnetCidr: subnetCidr
    location: location
  }
}

resource roleDef 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name:  guid(subscription().id, rg.id)
  properties: {
    roleName: 'Custom Role - Workspaces ${name} Regulus Deployment Permissions'
    description: 'Subscription level permissions for workspaces to create regulus deployments in there own resource groups'
    type: 'customRole'
    permissions: [
      {
        actions: [
          'Microsoft.Compute/disks/read'
          'Microsoft.Compute/disks/write'
          'Microsoft.Compute/disks/delete'
          'Microsoft.Compute/sshPublicKeys/read'
          'Microsoft.Compute/sshPublicKeys/write'
          'Microsoft.Compute/sshPublicKeys/delete'
          'Microsoft.Compute/virtualMachines/read'
          'Microsoft.Compute/virtualMachines/write'
          'Microsoft.Compute/virtualMachines/delete'
          'Microsoft.KeyVault/vaults/read'
          'Microsoft.KeyVault/vaults/write'
          'Microsoft.KeyVault/vaults/delete'
          'Microsoft.KeyVault/vaults/accessPolicies/write'
          'Microsoft.KeyVault/locations/operationResults/read'
          'Microsoft.KeyVault/locations/deletedVaults/purge/action'
          'Microsoft.ManagedIdentity/userAssignedIdentities/delete'
          'Microsoft.ManagedIdentity/userAssignedIdentities/assign/action'
          'Microsoft.ManagedIdentity/userAssignedIdentities/listAssociatedResources/action'
          'Microsoft.ManagedIdentity/userAssignedIdentities/read'
          'Microsoft.ManagedIdentity/userAssignedIdentities/write'
          'Microsoft.Network/virtualNetworks/read'
          'Microsoft.Network/virtualNetworks/write'
          'Microsoft.Network/virtualNetworks/delete'
          'Microsoft.Network/virtualNetworks/subnets/read'
          'Microsoft.Network/virtualNetworks/subnets/write'
          'Microsoft.Network/virtualNetworks/subnets/delete'
          'Microsoft.Network/virtualNetworks/subnets/join/action'
          'Microsoft.Network/networkInterfaces/read'
          'Microsoft.Network/networkInterfaces/write'
          'Microsoft.Network/networkInterfaces/delete'
          'Microsoft.Network/networkInterfaces/join/action'
          'Microsoft.Network/networkSecurityGroups/read'
          'Microsoft.Network/networkSecurityGroups/write'
          'Microsoft.Network/networkSecurityGroups/delete'
          'Microsoft.Network/networkSecurityGroups/securityRules/read'
          'Microsoft.Network/networkSecurityGroups/securityRules/write'
          'Microsoft.Network/networkSecurityGroups/securityRules/delete'
          'Microsoft.Network/networkSecurityGroups/join/action'
          'Microsoft.Network/publicIPAddresses/read'
          'Microsoft.Network/publicIPAddresses/write'
          'Microsoft.Network/publicIPAddresses/join/action'
          'Microsoft.Network/publicIPAddresses/delete'
          'Microsoft.Resources/subscriptions/resourcegroups/read'
          'Microsoft.Resources/subscriptions/resourcegroups/write'
          'Microsoft.Resources/subscriptions/resourcegroups/delete'
        ]
      }
    ]
    assignableScopes: [
      subscription().id
    ]
  }
}

output RoleDefinitionId string = roleDef.name
output NetworkName string = network.outputs.networkName
output SubnetName string = network.outputs.subnetName
