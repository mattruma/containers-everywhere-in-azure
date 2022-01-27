param containerRegistryName string
param longName string
param storageAccountName string
param logAnalyticsWorkspaceName string
param imageName string
param appInsightsName string
param aciApiName string

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

resource aciApi 'Microsoft.ContainerInstance/containerGroups@2021-09-01' existing = {
  name: aciApiName
}

resource aciApp 'Microsoft.ContainerInstance/containerGroups@2021-09-01' = {
  name: 'aci-app-${longName}'
  location: resourceGroup().location
  properties: {
    containers: [
      {
        name: 'app'
        properties: {
          image: toLower(imageName)
          environmentVariables: [
            {
              name: 'APP_INSIGHTS_CONNECTION_STRING'
              secureValue: appInsights.properties.ConnectionString
            }
            {
              name: 'BGN_API_ENDPOINT'
              value: 'http://${aciApi.properties.ipAddress.ip}'
            }
            {
              name: 'ASPNETCORE_ENVIRONMENT'
              value: 'Development'
            }
          ]
          ports: [
            {
              port: 80
            }
          ]
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 1
            }
          }
        }
      }
    ]
    osType: 'Linux'
    imageRegistryCredentials: [
      {
        username: containerRegistry.listCredentials().username
        server: containerRegistry.properties.loginServer
        password: containerRegistry.listCredentials().passwords[0].value
      }
    ]
    ipAddress: {
      type: 'Public'
      ports: [
        {
          port: 80
        }
      ]
    }
    // diagnostics: {
    //   logAnalytics: {
    //     workspaceId: logAnalyticsWorkspace.id
    //     workspaceKey: listKeys(logAnalyticsWorkspace.id, logAnalyticsWorkspace.apiVersion).primarySharedKey
    //   }
    // }
  }
}

output aciAppName string = aciApp.name
output aciAppIpAddress string = 'http://${aciApp.properties.ipAddress.ip}'
