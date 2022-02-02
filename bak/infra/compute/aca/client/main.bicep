param containerAppName string
param containerRegistryName string
param imageName string
param serverContainerAppName string
param storageAccountName string
param logAnalyticsWorkspaceName string
param appInsightsName string
param kubeEnvironmentName string

module containerAppsDeployment 'containerApps.bicep' = {
  name: 'clientContainerAppsDeployment'
  params: {
    containerRegistryName: containerRegistryName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    storageAccountName: storageAccountName
    imageName: imageName
    serverContainerAppName: serverContainerAppName
    appInsightsName: appInsightsName
    containerAppName: containerAppName
    kubeEnvironmentName: kubeEnvironmentName
  }
}

output clientContainerAppFqdn string = containerAppsDeployment.outputs.containerAppsAppFqdn
