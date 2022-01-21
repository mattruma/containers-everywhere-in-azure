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

resource aci 'Microsoft.ContainerInstance/containerGroups@2021-09-01' = {
  name: 'aci-${longName}'
  properties: {
    containers: [
      {
        name: 'app'
        properties: {
          image: appImageName
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
      {
        name: 'api'
        properties: {
          image: apiImageName
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
        server: containerRegistry.name
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
    diagnostics: {
      logAnalytics: {
        workspaceId: logAnalyticsWorkspace.id
        workspaceKey: listKeys(logAnalyticsWorkspace.id, logAnalyticsWorkspace.apiVersion).primarySharedKey
      }
    }
  }
}

output aciName string = aci.name
output aciIpAddress string = aci.properties.ipAddress.ip
