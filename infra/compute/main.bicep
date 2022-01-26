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

output aciAppName string = aciDeployment.outputs.aciAppName
output aciAppIpAddress string = aciDeployment.outputs.aciAppIpAddress
output aciApiName string = aciDeployment.outputs.aciApiName
output aciApiIpAddress string = aciDeployment.outputs.aciApiIpAddress
output appServiceName string = appServiceDeployment.outputs.appServiceName
output appServiceHostName string = appServiceDeployment.outputs.appServiceHostName
output apiServiceName string = appServiceDeployment.outputs.apiServiceName
output apiServiceHostName string = appServiceDeployment.outputs.apiServiceHostName
output containerAppsAppName string = containerAppsDeployment.outputs.containerAppsAppName
output containerAppsAppFqdn string = containerAppsDeployment.outputs.containerAppsAppFqdn
output containerAppsApiName string = containerAppsDeployment.outputs.containerAppsApiName
output containerAppsApiFqdn string = containerAppsDeployment.outputs.containerAppsApiFqdn
