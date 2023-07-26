@description('Name for the jupyter service virtual machine.')
param jupyterName string = 'jupyter'

@description('Username for the jupyter service virtual machine.')
param adminUsername string

@description('SSH public key value')
@secure()
param sshPublicKey string

@description('jupyter token value')
@secure()
param jupyterToken string

@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
param dnsLabelPrefix string = toLower('${jupyterName}-${uniqueString(resourceGroup().id)}')

@description('The Ubuntu version for the VM. This will pick a fully patched image of this given Ubuntu version.')
@allowed([
  'Ubuntu-1804'
  'Ubuntu-2004'
  'Ubuntu-2204'
])
param ubuntuOSVersion string = 'Ubuntu-2004'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('The size of the VM')
param vmSize string = 'Standard_D2s_v3'

@description('Name of the VNET')
param virtualNetworkName string = 'vNet'

@description('Name of the subnet in the virtual network')
param subnetName string = 'Subnet'

@description('Name of the Network Security Group')
param networkSecurityGroupName string = 'SecGroupNet'

@description('The CIDR ranges that can be used to communicate with the jupyter instance.')
param accessCidrs array

@description('port to access the jupyter service UI.')
param httpPort string = '8888'

@description('allow access the jupyter ssh port from the access cidr.')
param sshAccess bool = false

var imageReference = {
  'Ubuntu-1804': {
    publisher: 'Canonical'
    offer: 'UbuntuServer'
    sku: '18_04-lts-gen2'
    version: 'latest'
  }
  'Ubuntu-2004': {
    publisher: 'Canonical'
    offer: '0001-com-ubuntu-server-focal'
    sku: '20_04-lts-gen2'
    version: 'latest'
  }
  'Ubuntu-2204': {
    publisher: 'Canonical'
    offer: '0001-com-ubuntu-server-jammy'
    sku: '22_04-lts-gen2'
    version: 'latest'
  }
}
var publicIPAddressName = '${jupyterName}PublicIP'
var networkInterfaceName = '${jupyterName}NetInt'
var osDiskType = 'Standard_LRS'
var subnetAddressPrefix = '10.1.0.0/24'
var addressPrefix = '10.1.0.0/16'
var linuxConfiguration = {
  disablePasswordAuthentication: true
  ssh: {
    publicKeys: [
      {
        path: '/home/${adminUsername}/.ssh/authorized_keys'
        keyData: sshPublicKey
      }
    ]
  }
}

var trustedExtensionName = 'GuestAttestation'
var trustedExtensionPublisher = 'Microsoft.Azure.Security.LinuxAttestation'
var trustedExtensionVersion = '1.0'
var trustedMaaTenantName = 'GuestAttestation'
var trustedMaaEndpoint = substring('emptystring', 0, 0)
var dockerExtensionName = 'DockerExtension'
var dockerExtensionPublisher = 'Microsoft.Azure.Extensions'
var dockerExtensionVersion = '1.1'

var registry = 'teradata'
var repository = 'regulus-jupyter'
var version = 'latest'
var cloudInitData = base64(
  format(
    loadTextContent('templates/cloudinit.yaml'), 
    base64(
      format(
        loadTextContent('templates/jupyter.service'),
        registry,
        repository,
        version,
        httpPort,
        jupyterToken
      )
    )
  )
)

resource networkInterface 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: networkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: virtualNetworkName_subnet.id
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddress.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: networkSecurityGroup.id
    }
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          priority: 700
          protocol: 'Tcp'
          access: sshAccess ? 'Allow' : 'Deny'
          direction: 'Inbound'
          sourceAddressPrefixes: accessCidrs
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
      {
        name: 'HTTP'
        properties: {
          priority: 701
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefixes: accessCidrs
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: httpPort
        }
      }
    ]
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
  }
}

resource virtualNetworkName_subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  parent: virtualNetwork
  name: subnetName
  properties: {
    addressPrefix: subnetAddressPrefix
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: publicIPAddressName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    publicIPAddressVersion: 'IPv4'
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
    idleTimeoutInMinutes: 4
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: jupyterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
      }
      imageReference: imageReference[ubuntuOSVersion]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
    
    osProfile: {
      computerName: jupyterName
      adminUsername: adminUsername
      linuxConfiguration: linuxConfiguration
    }
    securityProfile: {
      encryptionAtHost: true
      securityType: 'TrustedLaunch'
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
    }
    userData: cloudInitData
  }
}



resource jupyterName_extension_trusted 'Microsoft.Compute/virtualMachines/extensions@2022-03-01' = {
  parent: vm
  name: trustedExtensionName
  location: location
  properties: {
    publisher: trustedExtensionPublisher
    type: trustedExtensionName
    typeHandlerVersion: trustedExtensionVersion
    autoUpgradeMinorVersion: true
    settings: {
      AttestationConfig: {
        MaaSettings: {
          maaEndpoint: trustedMaaEndpoint
          maaTenantName: trustedMaaTenantName
        }
      }
    }
  }
}

resource jupyterName_extension_docker 'Microsoft.Compute/virtualMachines/extensions@2023-03-01' = {
  parent: vm
  name: dockerExtensionName
  location: location
  properties: {
    publisher: dockerExtensionPublisher
    type: dockerExtensionName
    typeHandlerVersion: dockerExtensionVersion
    autoUpgradeMinorVersion: true
  }
}

<<<<<<<< HEAD:deployments/jupyter/platform/azure/resource-manager-template/arm-template.bicep
========
resource existingRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (customRoleName != '') {
  name: guid(subscription().id, vm.id, existingRoleDef.id)
  properties: {
    roleDefinitionId: existingRoleDef.id
    principalId: vm.identity.principalId
  }
}

resource newRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (customRoleName == '') {
  name: guid(subscription().id, vm.id, newRoleDef.id)
  properties: {
    roleDefinitionId: newRoleDef.id
    principalId: vm.identity.principalId
  }
}

@description('Custom Role Name.')
param customRoleName string = ''

resource existingRoleDef 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = if (customRoleName != '') {
  name: customRoleName
}

resource newRoleDef 'Microsoft.Authorization/roleDefinitions@2022-04-01' = if (customRoleName == '') {
  name:  '${workspacesName}-custom-role'
  properties: {
    roleName: 'Custom Role - Workspaces ${workspacesName} Regulus Deployment Permissions'
    description: 'Subscription level permissions for workspaces ${workspacesName} to create regulus deployments'
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

>>>>>>>> develop:deployments/workspaces/platform/azure/resource-manager-template/arm-template.bicep
output AdminUsername string = adminUsername
output PublicIP string = publicIPAddress.properties.ipAddress
output PrivateIP string = networkInterface.properties.ipConfigurations[0].properties.privateIPAddress
output PublicHttpAccess string = 'http://${ publicIPAddress.properties.dnsSettings.fqdn }:${ httpPort }'
output PrivateHttpAccess string = 'http://${ networkInterface.properties.ipConfigurations[0].properties.privateIPAddress }:${ httpPort }'
<<<<<<<< HEAD:deployments/jupyter/platform/azure/resource-manager-template/arm-template.bicep
========
output PublicGrpcAccess string = 'http://${ publicIPAddress.properties.dnsSettings.fqdn }:${ grpcPort }'
output PrivateGrpcAccess string = 'http://${ networkInterface.properties.ipConfigurations[0].properties.privateIPAddress }:${ grpcPort }'
>>>>>>>> develop:deployments/workspaces/platform/azure/resource-manager-template/arm-template.bicep
output SecurityGroup string = networkSecurityGroup.id
output sshCommand string = 'ssh ${adminUsername}@${publicIPAddress.properties.dnsSettings.fqdn}'
