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

output containerAppsAppName string = containerAppsDeployment.outputs.containerAppsAppName
output containerAppsApiName string = containerAppsDeployment.outputs.containerAppsApiName

output containerAppsApiFqdn string = containerAppsDeployment.outputs.containerAppsApiFqdn
output containerAppsAppFqdn string = containerAppsDeployment.outputs.containerAppsAppFqdn
