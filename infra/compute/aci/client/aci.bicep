param containerRegistryName string
param longName string
param storageAccountName string
param logAnalyticsWorkspaceName string
param imageName string
param appInsightsName string
param serverAciName string

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

resource aciServer 'Microsoft.ContainerInstance/containerGroups@2021-09-01' existing = {
  name: serverAciName
}

resource aciClient 'Microsoft.ContainerInstance/containerGroups@2021-09-01' = {
  name: 'aci-client-${longName}'
  location: resourceGroup().location
  properties: {
    containers: [
      {
        name: 'client'
        properties: {
          image: toLower('${containerRegistry.properties.loginServer}/${imageName}')
          environmentVariables: [
            {
              name: 'APP_INSIGHTS_CONNECTION_STRING'
              secureValue: appInsights.properties.ConnectionString
            }
            {
              name: 'BGN_API_ENDPOINT'
              value: 'http://${aciServer.properties.ipAddress.ip}'
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

output aciName string = aciClient.name
output aciIpAddress string = 'http://${aciClient.properties.ipAddress.ip}'
