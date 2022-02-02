param logWorkspaceName string
param appServicePlanName string
param appInsightsName string
param acrName string
param clientAppName string
param clientImageName string
param serverAppName string
param serverImageName string

resource logWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logWorkspaceName
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' existing = {
  name: appServicePlanName
}

resource registry 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' existing = {
  name: acrName
}

resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: appInsightsName
  location: resourceGroup().location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logWorkspace.id
  }
}

// resource clientApp 'microsoft.web/sites@2020-06-01' = {
//   name: clientAppName
//   location: resourceGroup().location
//   properties: {
//     siteConfig: {
//       appSettings: [
//         {
//           name: 'DOCKER_REGISTRY_SERVER_URL'
//           value: registry.name
//         }
//         {
//           name: 'DOCKER_REGISTRY_SERVER_USERNAME'
//           value: registry.listCredentials().username
//         }
//         {
//            name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
//            value: registry.listCredentials().passwords[0].value
//         }
//         {
//           name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
//           value: appInsights.properties.InstrumentationKey
//         }
//       ]
//       linuxFxVersion: clientImageName
//     }
//     serverFarmId: appServicePlan.id
//   }
// }

// resource serverApp 'microsoft.web/sites@2020-06-01' = {
//   name: serverAppName
//   location: resourceGroup().location
//   properties: {
//     siteConfig: {
//       appSettings: [
//         {
//           name: 'DOCKER_REGISTRY_SERVER_URL'
//           value: registry.name
//         }
//         {
//           name: 'DOCKER_REGISTRY_SERVER_USERNAME'
//           value: registry.listCredentials().username
//         }
//         {
//            name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
//            value: registry.listCredentials().passwords[0].value
//         }
//         {
//           name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
//           value: appInsights.properties.InstrumentationKey
//         }
//       ]
//       linuxFxVersion: serverImageName
//     }
//     serverFarmId: appServicePlan.id
//   }
// }
