param productId string

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

resource appAppInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: '${productId}appappi'
  location: resourceGroup().location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logWorkspace.id
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
    serverFarmId: appServicePlan.id
  }
}

resource apiAppInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: '${productId}apiappi'
  location: resourceGroup().location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logWorkspace.id
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
    serverFarmId: appServicePlan.id
  }
}
