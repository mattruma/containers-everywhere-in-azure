param appName string
param environment string
param location string
param containerRegistryName string
param imageName string
param serverContainerAppName string
param storageAccountName string
param logAnalyticsWorkspaceName string
param appInsightsName string
param kubeEnvironmentName string

module containerAppsDeployment 'containerApps.bicep' = {
  name: 'containerAppsDeployment'
  params: {
    containerRegistryName: containerRegistryName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    storageAccountName: storageAccountName
    imageName: imageName
    serverContainerAppName: serverContainerAppName
    appInsightsName: appInsightsName
    appName: appName
    kubeEnvironmentName: kubeEnvironmentName
  }
}

output clientContainerAppName string = containerAppsDeployment.outputs.containerAppsAppName
output clientContainerAppFqdn string = containerAppsDeployment.outputs.containerAppsAppFqdn
