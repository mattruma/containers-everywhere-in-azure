param containerRegistryName string
param longName string
param storageAccountName string
param logAnalyticsWorkspaceName string
param imageName string
param apiContainerAppName string
param appInsightsName string
param appName string
param kubeEnvironmentName string

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

resource apiContainerApp 'Microsoft.Web/containerApps@2021-03-01' existing = {
  name: apiContainerAppName
}

resource kubeEnvironment 'Microsoft.Web/kubeEnvironments@2021-02-01' existing = {
  name: kubeEnvironmentName
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
          image: toLower(imageName)
          resources: {
            cpu: 1
            memory: '2Gi'
          }
          env: [
            {
              name: 'BGN_API_ENDPOINT'
              value: 'https://${apiContainerApp.properties.configuration.ingress.fqdn}'
            }
          ]
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
output containerAppsAppFqdn string = 'http://${containerApp.properties.configuration.ingress.fqdn}'
