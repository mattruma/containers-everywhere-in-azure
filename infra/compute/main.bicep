param appName string
param environment string
param location string
param containerRegistryName string
param appImageName string
param apiImageName string
param storageAccountName string
param logAnalyticsWorkspaceName string
param appInsightsName string

var longName = '${appName}-${location}-${environment}'

module aciDeployment 'aci.bicep' = {
  name: 'aciDeployment'
  params: {
    containerRegistryName: containerRegistryName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    longName: longName
    storageAccountName: storageAccountName
    appImageName: appImageName
    apiImageName: apiImageName
    appInsightsName: appInsightsName
  }
}

module appServiceDeployment 'appService.bicep' = {
  name: 'appServiceDeployment'
  params: {
    containerRegistryName: containerRegistryName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    longName: longName
    storageAccountName: storageAccountName
    appInsightsName: appInsightsName
    appImageName: appImageName
    apiImageName: apiImageName
  }
}

// module aksDeployment 'aks.bicep' = {
//   name: 'aksDeployment'
//   params: {
//     containerRegistryName: containerRegistryName
//     logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
//     longName: longName
//     appName: appName
//     storageAccountName: storageAccountName
//     appInsightsName: appInsightsName
//   }
// }

module containerAppsDeployment 'containerApps.bicep' = {
  name: 'containerAppsDeployment'
  params: {
    containerRegistryName: containerRegistryName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    longName: longName
    storageAccountName: storageAccountName
    appImageName: appImageName
    apiImageName: apiImageName
    appInsightsName: appInsightsName
    appName: appName
  }
}

//output aksName string = aksDeployment.outputs.aksName
output aciAppName string = aciDeployment.outputs.aciAppName
output aciApiName string = aciDeployment.outputs.aciApiName
output appServiceName string = appServiceDeployment.outputs.appServiceName
output apiServiceName string = appServiceDeployment.outputs.apiServiceName
output containerAppsAppName string = containerAppsDeployment.outputs.containerAppsAppName
output containerAppsApiName string = containerAppsDeployment.outputs.containerAppsApiName
