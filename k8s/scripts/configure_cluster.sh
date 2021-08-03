#!/bin/bash

az extension add --name aks-preview
az extension update --name aks-preview
az aks update --resource-group $RSG_NAME --name $AKS_CLUSTER_NAME --attach-acr $ACR_NAME
az aks update --resource-group $RSG_NAME --name $AKS_CLUSTER_NAME --enable-pod-identity
az aks pod-identity add --resource-group $RSG_NAME --cluster-name $AKS_CLUSTER_NAME --namespace 'default' --name msi --identity-resource-id $MSI_RESOURCE_ID
