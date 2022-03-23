param location string = resourceGroup().location
param acrName string
param logWorkspaceName string
param storageAccountName string
param appServicePlanName string
param aksPipName string

resource registry 'Microsoft.ContainerRegistry/registries@2020-11-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

resource logWorkspace 'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' = {
  name: logWorkspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

resource storage 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource aksPip 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: aksPipName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

output registryId string = registry.id
output logWorkspaceId string = logWorkspace.id
output storage string = storage.id
output appServicePlanId string = appServicePlan.id
output aksPipId string = aksPip.id
