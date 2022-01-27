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

output appServiceName string = appServiceDeployment.outputs.appServiceName
output apiServiceName string = appServiceDeployment.outputs.apiServiceName

output apiServiceHostName string = appServiceDeployment.outputs.apiServiceHostName
output appServiceHostName string = appServiceDeployment.outputs.appServiceHostName
