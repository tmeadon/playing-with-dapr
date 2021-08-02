param baseName string
param location string
param msiName string

var vaultName = uniqueString(baseName, resourceGroup().id)

resource msi 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: msiName  
}

resource vault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: vaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    createMode: 'recover'
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        objectId: msi.properties.principalId
        tenantId: msi.properties.tenantId
        permissions: {
          secrets: [
            'get'
            'list'
          ]
        }
      }
    ]
  }
}

output vaultName string = vault.name
