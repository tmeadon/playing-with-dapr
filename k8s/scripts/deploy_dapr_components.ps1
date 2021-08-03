
$manifests = Get-ChildItem -Path ".\k8s\dapr-components"

foreach ($file in $manifests)
{
    $fileContents = Get-Content -Path $file.FullName -Raw
    $fileContents = $fileContents.Replace('{{ vault_name }}', $env:keyVaultName)
    $fileContents = $fileContents.Replace('{{ msi_client_id }}', $env:msiClientId)
    $fileContents = $fileContents.Replace('{{ cosmos_url }}', $env:cosmosUrl)
    $fileContents = $fileContents.Replace('{{ cosmos_db_name }}', $env:cosmosDbName)

    $cosmosCollections = $env:cosmosCollectionNames | ConvertFrom-Json

    0..$cosmosCollections.Count | ForEach-Object {
        $fileContents = $fileContents.Replace("{{ cosmos_collection_name_$($_) }}", $cosmosCollections[$_])
    }

    $fileContents | kubectl apply -f -
}