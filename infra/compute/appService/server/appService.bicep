param containerRegistryName string
param longName string
param storageAccountName string
param logAnalyticsWorkspaceName string
param appInsightsName string
param imageName string
param appServicePlanName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' existing = {
  name: storageAccountName
}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' existing = {
  name: containerRegistryName
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsightsName
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' existing = {
  name: appServicePlanName
}

resource appService 'Microsoft.Web/sites@2021-02-01' = {
  name: 'as-api-${longName}'
  location: resourceGroup().location
  kind: 'app,linux,container'
  properties: {    
    siteConfig: {
      appSettings: [
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: containerRegistry.name
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: containerRegistry.listCredentials().username
        }
        {
           name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
           value: containerRegistry.listCredentials().passwords[0].value
        }
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
      ]
    }
    serverFarmId: appServicePlan.id
  }
}

resource appWeb 'Microsoft.Web/sites/config@2021-02-01' = {
  name: '${appService.name}/web'
  properties: {
    linuxFxVersion: 'DOCKER|${imageName}'
  }
}

output appServicePlanName string = appServicePlan.name
output appServiceName string = appService.name
output appServiceHostName string = 'http://${appService.properties.defaultHostName}'