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

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: baseName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: workspace.id
  }
}

output resourceId string = workspace.id
