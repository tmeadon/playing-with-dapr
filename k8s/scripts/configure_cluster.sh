#!/bin/bash

az extension add --name aks-preview
az extension update --name aks-preview
az aks update --resource-group $RSG_NAME --name $AKS_CLUSTER_NAME --attach-acr $ACR_NAME --debug
az aks update --resource-group $RSG_NAME --name $AKS_CLUSTER_NAME --enable-pod-identity
IDENTITY_RESOURCE_ID="$(az identity show -g $RSG_NAME -n $MSI_NAME --query id -otsv)"
az aks pod-identity add --resource-group $RSG_NAME --cluster-name $AKS_CLUSTER_NAME --namespace 'default' --name msi --identity-resource-id $IDENTITY_RESOURCE_ID
