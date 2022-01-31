param productId string

module shared 'shared.bicep' = {
  name: 'shared'
  params: {
    productId: productId
  }
}

resource appAppInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: '${productId}conappappi'
  location: resourceGroup().location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: shared.outputs.logWorkspaceId
  }
}

resource appSite 'microsoft.web/sites@2020-06-01' = {
  name: '${productId}conapp'
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    siteConfig: {
      acrUseManagedIdentityCreds: true
      appSettings: [
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
      ]
      linuxFxVersion: 'DOCKER|mcr.microsoft.com/appsvc/staticsite:latest'
    }
    serverFarmId: shared.outputs.appServicePlanId
  }
}

resource apiAppInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: '${productId}conapiappi'
  location: resourceGroup().location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: shared.outputs.logWorkspaceId
  }
}

resource apiSite 'microsoft.web/sites@2020-06-01' = {
  name: '${productId}conapi'
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    siteConfig: {
      acrUseManagedIdentityCreds: true
      appSettings: [
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
      ]
      linuxFxVersion: 'DOCKER|mcr.microsoft.com/appsvc/staticsite:latest'
    }
    serverFarmId: shared.outputs.appServicePlanId
  }
}
