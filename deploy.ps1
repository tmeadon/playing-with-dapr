$resourceGroupName = 'dapr-testing'
$location = 'uksouth'

# deploy main iac template
$params = @{
    TemplateFile = './iac/main.bicep'
    Location     = $location
    baseName     = $resourceGroupName
    Verbose      = $true
}
$mainDeploy = New-AzDeployment @params

# deploy additional role assignments
$params = @{
    ResourceGroupName   = $mainDeploy.Outputs['aksNodeResourceGroup'].Value
    TemplateFile        = './iac/nodesRsgPerms.bicep'
    assigneePrincipalId = $mainDeploy.Outputs['msiPrincipalId'].Value
    Verbose             = $true
}
New-AzResourceGroupDeployment @params | Out-Null

# enable aad pod identity
az aks get-credentials --name $mainDeploy.Outputs['aksClusterName'].Value --resource-group $resourceGroupName
az aks update --resource-group $resourceGroupName --name  $mainDeploy.Outputs['aksClusterName'].Value --enable-pod-identity
az aks pod-identity add --resource-group $resourceGroupName --cluster-name  $mainDeploy.Outputs['aksClusterName'].Value --namespace 'default' --name msi --identity-resource-id $azureDeploy.Outputs['msiResourceId'].Value

# deploy dapr
helm repo add dapr https://dapr.github.io/helm-charts/
helm repo update
helm upgrade --install dapr dapr/dapr `
--version=1.3 `
--namespace dapr-system `
--create-namespace `
--wait

# deploy secret store
$file = Get-Item -Path '.\k8s\dapr-secret-store.yaml'
$fileContents = Get-Content -Path $file.FullName -Raw
$fileContents = $fileContents.Replace('{{ vault_name }}', $mainDeploy.Outputs['keyVaultName'].Value)
$fileContents = $fileContents.Replace('{{ msi_client_id }}', $mainDeploy.Outputs['msiClientId'].Value)
$fileContents | kubectl apply -f -

# deploy test pod (with curl installed)
kubectl apply -f './k8s/busybox-basic.yaml'

# deploy redis component
$file = Get-Item -Path '.\k8s\dapr-redis.yaml'
$fileContents = Get-Content -Path $file.FullName -Raw
$fileContents = $fileContents.Replace('{{ redis_host_and_port }}', $mainDeploy.Outputs['redisHostAndPort'].Value)
$fileContents = $fileContents.Replace('{{ redis_key_secret_name }}', $mainDeploy.Outputs['redisKeySecretName'].Value)
$fileContents | kubectl apply -f -


