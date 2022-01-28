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

resource appAppInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: '${productId}conappappi'
  location: resourceGroup().location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logWorkspace.id
  }
}

resource appSite 'microsoft.web/sites@2020-06-01' = {
  name: '${productId}conapp'
  location: resourceGroup().location
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: ''
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'https://mcr.microsoft.com'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: ''
        }
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
      ]
      linuxFxVersion: 'DOCKER|mcr.microsoft.com/appsvc/staticsite:latest'
    }
    serverFarmId: appServicePlan.id
  }
}

resource apiAppInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: '${productId}conapiappi'
  location: resourceGroup().location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logWorkspace.id
  }
}

resource apiSite 'microsoft.web/sites@2020-06-01' = {
  name: '${productId}conapi'
  location: resourceGroup().location
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: ''
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'https://mcr.microsoft.com'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: ''
        }
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
      ]
      linuxFxVersion: 'DOCKER|mcr.microsoft.com/appsvc/staticsite:latest'
    }
    serverFarmId: appServicePlan.id
  }
}
