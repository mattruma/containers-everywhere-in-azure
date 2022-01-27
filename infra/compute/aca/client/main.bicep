param appName string
param environment string
param location string
param containerRegistryName string
param imageName string
param apiContainerAppName string
param storageAccountName string
param logAnalyticsWorkspaceName string
param appInsightsName string
param kubeEnvironmentName string

var longName = '${appName}-${location}-${environment}'

module containerAppsDeployment 'containerApps.bicep' = {
  name: 'containerAppsDeployment'
  params: {
    containerRegistryName: containerRegistryName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    longName: longName
    storageAccountName: storageAccountName
    imageName: imageName
    apiContainerAppName: apiContainerAppName
    appInsightsName: appInsightsName
    appName: appName
    kubeEnvironmentName: kubeEnvironmentName
  }
}

output clientContainerAppName string = containerAppsDeployment.outputs.containerAppsAppName
output clientContainerAppFqdn string = containerAppsDeployment.outputs.containerAppsAppFqdn
