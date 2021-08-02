targetScope = 'subscription'

param baseName string //= 'dapr-testing'
param location string = deployment().location

resource rsg 'Microsoft.Resources/resourceGroups@2020-10-01' = {
  name: baseName
  location: location
  tags: {
    destroyTime: '18:00'
  }
}

module aks 'aks.bicep' = {
  scope: rsg
  name: 'aks'
  params: {
    clusterName: baseName
    location: location
  }
}

module identity 'identity.bicep' = {
  scope: rsg
  name: 'identity'
  params: {
    location: location
    name: '${baseName}-msi'
  }
}

module keyVault 'keyvault.bicep' = {
  scope: rsg
  name: 'keyvault'
  params: {
    location: location
    msiName: identity.outputs.msiName
    baseName: baseName
  }
}

output aksClusterName string = aks.outputs.clusterName
output aksNodeResourceGroup string = aks.outputs.nodeResourceGroup
output msiResourceId string = identity.outputs.msiResourceId
output msiPrincipalId string = identity.outputs.msiPrincipalId
output msiClientId string = identity.outputs.msiClientId
output msiName string = identity.outputs.msiName
output keyVaultName string = keyVault.outputs.vaultName
