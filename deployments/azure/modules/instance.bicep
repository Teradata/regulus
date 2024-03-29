param location string
param name string
param adminUsername string
param sshPublicKey string
param dnsLabelPrefix string = toLower('${name}-${uniqueString(resourceGroup().id)}')
param vmSize string
param subnetId string
param networkSecurityGroupID string
param httpPort string
param grpcPort string
param ubuntuOSVersion string

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

var publicIPAddressName = '${name}PublicIP'
var networkInterfaceName = '${name}NetInt'
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
var version = 'devtest' //'latest'
var cloudInitData = base64(
  format(
    loadTextContent('../templates/workspaces.cloudinit.yaml'), 
    base64(
      format(
        loadTextContent('../templates/workspaces.service'),
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
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddress.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: networkSecurityGroupID
    }
  }
}

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2022-11-01' = {
  name: publicIPAddressName
  location: location
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
  name: name
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
      computerName: name
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

resource workspacesName_extension_docker 'Microsoft.Compute/virtualMachines/extensions@2023-03-01' = {
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

output PublicIP string = publicIPAddress.properties.ipAddress
output PrivateIP string = networkInterface.properties.ipConfigurations[0].properties.privateIPAddress
output PrincipleId string = vm.identity.principalId
