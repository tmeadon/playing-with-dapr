param assigneePrincipalId string

var vmContributorRoleId = '9980e02c-c2be-4d73-94e8-173b1dc7cf3c'

resource aksVmContributor 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(assigneePrincipalId, resourceGroup().id, vmContributorRoleId)
  properties: {
    principalId: assigneePrincipalId
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', vmContributorRoleId)
  }
}
