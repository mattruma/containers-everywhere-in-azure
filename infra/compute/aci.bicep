param containerRegistryName string
param longName string
param storageAccountName string
param logAnalyticsWorkspaceName string
param appImageName string
param apiImageName string
param appInsightsName string

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

resource aciApp 'Microsoft.ContainerInstance/containerGroups@2021-09-01' = {
  name: 'aci-app-${longName}'
  location: resourceGroup().location
  properties: {
    containers: [
      {
        name: 'app'
        properties: {
          image: toLower(appImageName)
          environmentVariables: [
            {
              name: 'APP_INSIGHTS_CONNECTION_STRING'
              secureValue: appInsights.properties.ConnectionString
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

resource aciApi 'Microsoft.ContainerInstance/containerGroups@2021-09-01' = {
  name: 'aci-api-${longName}'
  location: resourceGroup().location
  properties: {
    containers: [
      {
        name: 'api'
        properties: {
          image: toLower(apiImageName)
          environmentVariables: [
            {
              name: 'APP_INSIGHTS_CONNECTION_STRING'
              secureValue: appInsights.properties.ConnectionString
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
output aciApiName string = aciApi.name
output aciAppIpAddress string = aciApp.properties.ipAddress.ip
output aciApiIpAddress string = aciApi.properties.ipAddress.ip
