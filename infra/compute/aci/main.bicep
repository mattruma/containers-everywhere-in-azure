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
  }
}

output aciAppName string = aciDeployment.outputs.aciAppName
output aciApiName string = aciDeployment.outputs.aciApiName

output aciApiIpAddress string = aciDeployment.outputs.aciApiIpAddress
output aciAppIpAddress string = aciDeployment.outputs.aciAppIpAddress
