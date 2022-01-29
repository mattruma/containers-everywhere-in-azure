param appServiceName string
param containerRegistryName string
param imageName string
param storageAccountName string
param logAnalyticsWorkspaceName string
param appInsightsName string
param appServicePlanName string

module appServiceDeployment 'appService.bicep' = {
  name: 'serverAppServiceDeployment'
  params: {
    containerRegistryName: containerRegistryName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    appServiceName: appServiceName
    storageAccountName: storageAccountName
    appInsightsName: appInsightsName
    imageName: imageName
    appServicePlanName: appServicePlanName
  }
}

output serverAppServiceHostName string = appServiceDeployment.outputs.appServiceHostName
