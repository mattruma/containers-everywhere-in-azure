param productId string

module shared 'shared.bicep' = {
  name: 'shared'
  params: {
    productId: productId
  }
}

resource appAppInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: '${productId}appappi'
  location: resourceGroup().location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: shared.outputs.logWorkspaceId
  }
}

resource appSite 'microsoft.web/sites@2020-06-01' = {
  name: '${productId}app'
  location: resourceGroup().location
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|6.0'
    }
    serverFarmId: shared.outputs.appServicePlanId
  }
}

resource apiAppInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: '${productId}apiappi'
  location: resourceGroup().location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: shared.outputs.logWorkspaceId
  }
}

resource apiSite 'microsoft.web/sites@2020-06-01' = {
  name: '${productId}api'
  location: resourceGroup().location
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: shared.outputs.appServicePlanId
  }
}
