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
output aciApiName string = aciDeployment.outputs.aciApiName
output appServiceName string = appServiceDeployment.outputs.appServiceName
output apiServiceName string = appServiceDeployment.outputs.apiServiceName
output containerAppsAppName string = containerAppsDeployment.outputs.containerAppsAppName
output containerAppsApiName string = containerAppsDeployment.outputs.containerAppsApiName

output aciApiIpAddress string = aciDeployment.outputs.aciApiIpAddress
output aciAppIpAddress string = aciDeployment.outputs.aciAppIpAddress
output apiServiceHostName string = appServiceDeployment.outputs.apiServiceHostName
output appServiceHostName string = appServiceDeployment.outputs.appServiceHostName
output containerAppsApiFqdn string = containerAppsDeployment.outputs.containerAppsApiFqdn
output containerAppsAppFqdn string = containerAppsDeployment.outputs.containerAppsAppFqdn
