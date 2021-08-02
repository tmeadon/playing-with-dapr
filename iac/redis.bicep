param baseName string
param location string

var redisName = uniqueString(resourceGroup().id, baseName)

resource redis 'Microsoft.Cache/redis@2020-12-01' = {
  name: redisName
  location: location
  properties: {
    sku: {
      capacity: 1
      family: 'C'
      name: 'Basic'
    }
  }
}

output redisHostName string = redis.properties.hostName
output redisPort int = redis.properties.sslPort
output redisKey string = redis.listKeys().primaryKey
