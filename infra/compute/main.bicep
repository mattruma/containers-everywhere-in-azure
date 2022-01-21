param appName string
param environment string
param location string
param containerRegistryName string
param appImageName string
param apiImageName string
param storageAccountName string
param logAnalyticsWorkspaceName string
param appInsightsName string
param managedIdentityName string

var longName = '${appName}-${location}-${environment}'

module aciDeployment 'aci.bicep' = {
  name: 'aciDeployment'
  params: {
    containerRegistryName: containerRegistryName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    longName: longName
    storageAccountName: storageAccountName
    appImageName: appImageName
    apiImageName: apiImageName
    appInsightsName: appInsightsName
    managedIdentityName: managedIdentityName
  }
}

module appServiceDeployment 'appService.bicep' = {
  name: 'appServiceDeployment'
  params: {
    containerRegistryName: containerRegistryName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    longName: longName
    storageAccountName: storageAccountName
    appInsightsName: appInsightsName
    managedIdentityName: managedIdentityName
  }
}

module aksDeployment 'aks.bicep' = {
  name: 'aksDeployment'
  params: {
    containerRegistryName: containerRegistryName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    longName: longName
    appName: appName
    storageAccountName: storageAccountName
    appInsightsName: appInsightsName
    managedIdentityName: managedIdentityName
  }
}

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
    managedIdentityName: managedIdentityName
    appName: appName
  }
}

output aksName string = aksDeployment.outputs.aksName
output aciName string = aciDeployment.outputs.aciName
output appServiceName string = appServiceDeployment.outputs.appServiceName
output containerAppsName string = containerAppsDeployment.outputs.containerAppsName
