param appServicePlanName string
param demoAppName string
param appServiceClientAppName string
param appServiceServerAppName string
param appServiceContainerClientAppName string
param appServiceContainerServerAppName string
param aciClientAppName string
param aciServerAppName string
param acaClientAppName string
param acaServerAppName string

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

resource aciClientApp 'Microsoft.ContainerInstance/containerGroups@2021-09-01' existing = {
  name: aciClientAppName
}

resource aciServerApp 'Microsoft.ContainerInstance/containerGroups@2021-09-01' existing = {
  name: aciServerAppName
}

resource acaClientApp 'Microsoft.Web/containerApps@2021-03-01' existing = {
  name: acaClientAppName
}

resource acaServerApp 'Microsoft.Web/containerApps@2021-03-01' existing = {
  name: acaServerAppName
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
          value: 'http://${aciServerApp.properties.ipAddress.ip}/swagger/index.html'
        }
        {
          name: 'ACI_CLIENT_URL'
          value: 'http://${aciClientApp.properties.ipAddress.ip}'
        }
        {
          name: 'ACA_SERVER_URL'
          value: 'https://${acaServerApp.properties.configuration.ingress.fqdn}/swagger/index.html'
        }
        {
          name: 'ACA_CLIENT_URL'
          value: 'https://${acaClientApp.properties.configuration.ingress.fqdn}'
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
