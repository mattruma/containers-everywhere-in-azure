param appServicePlanName string
param demoAppName string
param appServiceClientAppName string
param appServiceServerAppName string
param appServiceContainerClientAppName string
param appServiceContainerServerAppName string

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' existing = {
  name: appServicePlanName
}

resource appServiceClientApp 'microsoft.web/sites@2020-06-01' existing = {
  name: appServiceClientAppName
}

resource appServiceServerApp 'microsoft.web/sites@2020-06-01' existing = {
  name: appServiceServerAppName
}

resource appServiceContainerClientApp 'microsoft.web/sites@2020-06-01' existing = {
  name: appServiceContainerClientAppName
}

resource appServiceContainerServerApp 'microsoft.web/sites@2020-06-01' existing = {
  name: appServiceContainerServerAppName
}

resource demoApp 'microsoft.web/sites@2020-06-01' = {
  name: demoAppName
  location: resourceGroup().location
  kind: 'app'
  properties: {
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|6.0'
      appSettings: [
        {
          name: 'APP_SERVICE_SERVER_URL'
          value: 'https://${appServiceServerApp.properties.defaultHostName}/swagger/index.html'
        }
        {
          name: 'APP_SERVICE_CLIENT_URL'
          value: 'https://${appServiceClientApp.properties.defaultHostName}'
        }
        {
          name: 'APP_SERVICE_CONTAINER_SERVER_URL'
          value: 'https://${appServiceContainerServerApp.properties.defaultHostName}/swagger/index.html'
        }
        {
          name: 'APP_SERVICE_CONTAINER_CLIENT_URL'
          value: 'https://${appServiceContainerClientApp.properties.defaultHostName}'
        }
        {
          name: 'ACI_SERVER_URL'
          value: 'false'
        }
        {
          name: 'ACI_CLIENT_URL'
          value: 'false'
        }
        {
          name: 'ACA_SERVER_URL'
          value: 'false'
        }
        {
          name: 'ACA_CLIENT_URL'
          value: 'false'
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
