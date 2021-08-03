param baseName string
param location string
param numAppContainers int

var accountName = uniqueString(resourceGroup().id, baseName)

resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2020-09-01' = {
  name: accountName
  location: location
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
        failoverPriority: 0
      }
    ]
    enableMultipleWriteLocations: false
  }
  kind: 'GlobalDocumentDB'

  resource database 'sqlDatabases' = {
    name: 'db'
    properties: {
      resource: {
        id: 'db'
      }
      options: {
        throughput: 400
      }
    }

    resource containers 'containers' = [for item in range(0, numAppContainers): {
      name: 'app${item}'
      properties: {
        options: {}
        resource: {
          id: 'app${item}'
          partitionKey: {
            paths: [
              '/id'
            ]
          }
        }
      }
    }]
  } 
}

output url string = cosmos.properties.documentEndpoint
output masterKey string = cosmos.listKeys().primaryMasterKey
output dbName string = cosmos::database.name
output appCollections array = [for i in range(0, numAppContainers): cosmos::database::containers[i].name]

