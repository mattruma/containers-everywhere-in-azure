param appName string
param environment string
param location string
param containerRegistryName string
param imageName string
param storageAccountName string
param logAnalyticsWorkspaceName string
param appInsightsName string
param apiServiceName string
param appServicePlanName string

var longName = '${appName}-${location}-${environment}'

module appServiceDeployment 'appService.bicep' = {
  name: 'appServiceDeployment'
  params: {
    containerRegistryName: containerRegistryName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    longName: longName
    storageAccountName: storageAccountName
    appInsightsName: appInsightsName
    imageName: imageName
    apiServiceName: apiServiceName
    appServicePlanName: appServicePlanName
  }
}

output clientAppServiceName string = appServiceDeployment.outputs.appServiceName
output clientAppServiceHostName string = appServiceDeployment.outputs.appServiceHostName
