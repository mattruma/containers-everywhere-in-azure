param appServiceName string
param containerRegistryName string
param imageName string
param storageAccountName string
param logAnalyticsWorkspaceName string
param appInsightsName string
param serverAppServiceName string
param appServicePlanName string

module appServiceDeployment 'appService.bicep' = {
  name: 'clientAppServiceDeployment'
  params: {
    containerRegistryName: containerRegistryName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    appServiceName: appServiceName
    storageAccountName: storageAccountName
    appInsightsName: appInsightsName
    imageName: imageName
    serverAppServiceName: serverAppServiceName
    appServicePlanName: appServicePlanName
  }
}

output clientAppServiceHostName string = appServiceDeployment.outputs.appServiceHostName
