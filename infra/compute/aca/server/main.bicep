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
  name: 'serverContainerAppsDeployment'
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

output serverContainerAppName string = containerAppsDeployment.outputs.containerAppName
output serverContainerAppFqdn string = containerAppsDeployment.outputs.containerAppFqdn
