param productId string

resource registry 'Microsoft.ContainerRegistry/registries@2020-11-01-preview' = {
  name: '${productId}acr'
  location: resourceGroup().location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

resource logWorkspace 'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' = {
  name: '${productId}log'
  location: resourceGroup().location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: '${productId}plan'
  location: resourceGroup().location
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

output logWorkspaceId string = logWorkspace.id
output appServicePlanId string = appServicePlan.id
