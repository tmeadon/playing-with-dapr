param clusterName string
param location string

resource cluster 'Microsoft.ContainerService/managedClusters@2021-02-01' = {
  name: clusterName
  location: location
  properties: {
    kubernetesVersion: '1.21.1'
    enableRBAC: true
    dnsPrefix: '${clusterName}-dns'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: 30
        count: 2
        vmSize: 'Standard_B2s'
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        mode: 'System'
        maxPods: 110
      }
    ]
    networkProfile: {
      loadBalancerSku: 'basic'
      networkPlugin: 'azure'
    }
    apiServerAccessProfile: {
      enablePrivateCluster: false
    }
    addonProfiles:{
      httpApplicationRouting: {
        enabled: false
      }
      azurePolicy: {
        enabled: true
      }
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

output clusterName string = cluster.name
output nodeResourceGroup string = cluster.properties.nodeResourceGroup
output kubeletIdentityClientId string = cluster.properties.identityProfile.kubeletidentity.clientId

