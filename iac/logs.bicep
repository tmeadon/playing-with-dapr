param baseName string
param location string

resource workspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: baseName
  location: location
  properties: {
    sku: {
      name: 'Standard'
    }
  }  
}

output resourceId string = workspace.id
