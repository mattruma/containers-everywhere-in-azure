param containerAppName string
param containerRegistryName string
param imageName string
param storageAccountName string
param logAnalyticsWorkspaceName string
param appInsightsName string
param kubeEnvironmentName string

module containerAppsDeployment 'containerApps.bicep' = {
  name: 'serverContainerAppsDeployment'
  params: {
    containerRegistryName: containerRegistryName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    storageAccountName: storageAccountName
    imageName: imageName
    appInsightsName: appInsightsName
    containerAppName: containerAppName
    kubeEnvironmentName: kubeEnvironmentName
  }
}

output serverContainerAppFqdn string = containerAppsDeployment.outputs.containerAppFqdn
