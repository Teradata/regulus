@description('Name for the workspaces service virtual machine.')
param workspacesName string

@description('Username for the workspaces service virtual machine.')
param adminUsername string = 'azureuser'

@description('SSH public key value')
@secure()
param sshPublicKey string

@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
param dnsLabelPrefix string = toLower('${workspacesName}-${uniqueString(resourceGroup().id)}')

@description('The Ubuntu version for the VM. This will pick a fully patched image of this given Ubuntu version.')
@allowed([
  'Ubuntu-1804'
  'Ubuntu-2004'
  'Ubuntu-2204'
])
param ubuntuOSVersion string = 'Ubuntu-2004'

@description('The size of the VM')
param vmSize string = 'Standard_D2s_v3'

@description('Name of the subnet to run Workspaces in')
param subnetName string

@description('Name of the Network Security Group')
param networkSecurityGroupName string = 'WorkspacesSecurityGroup'

@description('The CIDR ranges that can be used to communicate with the workspaces instance.')
param accessCidrs array = ['0.0.0.0/0']

@description('port to access the workspaces service UI.')
param httpPort string = '3000'

@description('port to access the workspaces service api.')
param grpcPort string = '3282'

@description('GUID of the Workspaces Role')
param roleDefinitionId string

@description('allow access the workspaces ssh port from the access cidr.')
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
var publicIPAddressName = '${workspacesName}PublicIP'
var networkInterfaceName = '${workspacesName}NetInt'
var osDiskType = 'Standard_LRS'
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
var repository = 'regulus-workspaces'
var version = 'latest'
var cloudInitData = base64(
  format(
    loadTextContent('templates/cloudinit.yaml'), 
    base64(
      format(
        loadTextContent('templates/workspaces.service'),
        registry,
        repository,
        version,
        httpPort,
        grpcPort,
        subscription().subscriptionId,
        subscription().tenantId 
      )
    )
  )
)

resource networkInterface 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  name: networkInterfaceName
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetName 
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

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  name: networkSecurityGroupName
  location: resourceGroup().location
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
      {
        name: 'GRPC'
        properties: {
          priority: 702
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefixes: accessCidrs
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: grpcPort
        }
      }
    ]
  }
}

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2022-11-01' = {
  name: publicIPAddressName
  location: resourceGroup().location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
    idleTimeoutInMinutes: 4
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: workspacesName
  location: resourceGroup().location
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
      computerName: workspacesName
      adminUsername: adminUsername
      linuxConfiguration: linuxConfiguration
    }
    securityProfile: {
      securityType: 'TrustedLaunch'
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
    }
    userData: cloudInitData
  }
}

resource workspacesName_extension_trusted 'Microsoft.Compute/virtualMachines/extensions@2023-03-01' = {
  parent: vm
  name: trustedExtensionName
  location: resourceGroup().location
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

resource workspacesName_extension_docker 'Microsoft.Compute/virtualMachines/extensions@2023-03-01' = {
  parent: vm
  name: dockerExtensionName
  location: resourceGroup().location
  properties: {
    publisher: dockerExtensionPublisher
    type: dockerExtensionName
    typeHandlerVersion: dockerExtensionVersion
    autoUpgradeMinorVersion: true
  }
}

resource roleDef 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name:  roleDefinitionId
}
resource existingRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, resourceGroup().id, roleDef.id, vm.id)
  properties: {
    roleDefinitionId: roleDef.id
    principalId: vm.identity.principalId
  }
}

output AdminUsername string = adminUsername
// output PublicIP string = publicIPAddress.properties.ipAddress
output PrivateIP string = networkInterface.properties.ipConfigurations[0].properties.privateIPAddress
output PublicHttpAccess string = 'http://${ publicIPAddress.properties.dnsSettings.fqdn }:${ httpPort }'
output PrivateHttpAccess string = 'http://${ networkInterface.properties.ipConfigurations[0].properties.privateIPAddress }:${ httpPort }'
output PublicGrpcAccess string = 'http://${ publicIPAddress.properties.dnsSettings.fqdn }:${ grpcPort }'
output PrivateGrpcAccess string = 'http://${ networkInterface.properties.ipConfigurations[0].properties.privateIPAddress }:${ grpcPort }'
output SecurityGroup string = networkSecurityGroup.id
output sshCommand string = 'ssh ${adminUsername}@${publicIPAddress.properties.dnsSettings.fqdn}'
