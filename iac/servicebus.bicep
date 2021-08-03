param baseName string
param location string

var namespaceName = uniqueString(baseName, resourceGroup().id)

resource namespace 'Microsoft.ServiceBus/namespaces@2021-01-01-preview' = {
  name: namespaceName
  location: location
  sku: {
    name: 'Standard'
  }

  resource authRule 'AuthorizationRules' = {
    name: 'dapr'
    properties: {
      rights: [
        'Listen'
        'Send'
        'Manage' 
      ]
    }
  }
}

output connectionString string = namespace::authRule.listKeys().primaryConnectionString
