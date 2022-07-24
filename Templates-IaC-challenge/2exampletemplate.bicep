param location string = resourceGroup().location
param storageAccountName string = 'templateiac${uniqueString(resourceGroup().id)}'
param appServiceAppName string = 'templateiac${uniqueString(resourceGroup().id)}'

var appServicePlanName = 'templateiac-appplan'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: 'templateiacstorage'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

resource appServicePlan 'Microsoft.Web/serverFarms@2021-03-01' = {
  name: 'templateiacappplan1'
  location: location
  sku: {
    name: 'F1'
  }
}

resource appServiceApp 'Microsoft.Web/sites@2021-03-01' = {
  name: 'templateiacapp1'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}
