param containerRegistryName string
param longName string
param storageAccountName string
param logAnalyticsWorkspaceName string
param appImageName string
param apiImageName string
param appInsightsName string
param appName string

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

resource kubeEnvironment 'Microsoft.Web/kubeEnvironments@2021-02-01' = {
  name: 'ke-${longName}'
  location: resourceGroup().location
  properties: {
    type: 'managed'
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsWorkspace.properties.customerId
        sharedKey: listKeys(logAnalyticsWorkspace.id, logAnalyticsWorkspace.apiVersion).primarySharedKey
      }
    }
  }
}

var containerRegistrySecretPasswordName = 'container-registry-password'

resource containerApp 'Microsoft.Web/containerApps@2021-03-01' = {
  name: toLower('ca-app-${appName}')
  location: resourceGroup().location
  properties: {
    kubeEnvironmentId: kubeEnvironment.id
    configuration: {
      activeRevisionsMode: 'single'
      ingress: {
        external: true
        targetPort: 80
        allowInsecure: false
        traffic: [
          {
            latestRevision: true
            weight: 100
          }
        ]
      }
      secrets: [
        {
          name: containerRegistrySecretPasswordName
          value: containerRegistry.listCredentials().passwords[0].value
        }
      ]
      registries: [
      {
        server: containerRegistry.properties.loginServer
        username: containerRegistry.listCredentials().username
        passwordSecretRef: containerRegistrySecretPasswordName
      }
      ]
    }
    template: {
      containers: [
        {
          name: 'app'
          image: toLower(appImageName)
          resources: {
            cpu: 1
            memory: '2Gi'
          }
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
    }
  }
}

resource containerApi 'Microsoft.Web/containerApps@2021-03-01' = {
  name: toLower('ca-api-${appName}')
  location: resourceGroup().location
  properties: {
    kubeEnvironmentId: kubeEnvironment.id
    configuration: {
      activeRevisionsMode: 'single'
      ingress: {
        external: true
        targetPort: 80
        allowInsecure: false
        traffic: [
          {
            latestRevision: true
            weight: 100
          }
        ]
      }
      secrets: [
        {
          name: containerRegistrySecretPasswordName
          value: containerRegistry.listCredentials().passwords[0].value
        }
      ]
      registries: [
      {
        server: containerRegistry.properties.loginServer
        username: containerRegistry.listCredentials().username
        passwordSecretRef: containerRegistrySecretPasswordName
      }
      ]
    }
    template: {
      containers: [
        {
          name: 'api'
          image: toLower(apiImageName)
          resources: {
            cpu: 1
            memory: '2Gi'
          }
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
    }
  }
}

output containerAppsAppName string = containerApp.name
output containerAppsApiName string = containerApi.name
