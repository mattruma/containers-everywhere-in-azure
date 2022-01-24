param appName string
param environment string
param location string

var longName = '${appName}-${location}-${environment}'

module loggingDeployment 'logging.bicep' = {
  name: 'loggingDeployment'
  params: {
    longName: longName
  }
}

module storageDeployment 'storage.bicep' = {
  name: 'storageDeployment'
  params: {
    longName: longName
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
  }
}

module containerRegistryDeployment 'acr.bicep' = {
  name: 'containerRegistryDeployment'
  params: {
    longName: longName
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
  }
}

// module managedIdentityDeployment 'managedIdentity.bicep' = {
//   name: 'managedIdentityDeployment'
//   params: {
//     containerRegistryName: containerRegistryDeployment.outputs.containerRegistryName
//     longName: longName
//   }
// }

output storageAccountName string = storageDeployment.outputs.storageAccountName
output containerRegistryName string = containerRegistryDeployment.outputs.containerRegistryName
output logAnalyticsWorkspaceName string = loggingDeployment.outputs.logAnalyticsWorkspaceName
output appInsightsName string = loggingDeployment.outputs.appInsightsName
// output managedIdentityName string = managedIdentityDeployment.outputs.managedIdentityName
