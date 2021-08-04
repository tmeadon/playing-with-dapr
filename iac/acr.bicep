param baseName string
param location string
param aksClientId string

var acrName = uniqueString(resourceGroup().id, baseName)
var acrPullRoleId = '7f951dda-4ed3-4680-a7ca-43fe172d538d'

resource acr 'Microsoft.ContainerRegistry/registries@2020-11-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: false
  }
}

resource acrPullRole 'Microsoft.Authorization/roleAssignments@2020-03-01-preview' = {
  name: guid(acr.id, aksClientId, acrPullRoleId)
  properties: {
    principalId: aksClientId
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', acrPullRoleId)
  }
  scope: acr
}

output acrName string = acr.name
