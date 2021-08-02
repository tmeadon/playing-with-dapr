param name string
param location string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: name
  location: location  
}

output msiName string = managedIdentity.name
output msiResourceId string = managedIdentity.id
output msiClientId string = managedIdentity.properties.clientId
output msiPrincipalId string = managedIdentity.properties.principalId
