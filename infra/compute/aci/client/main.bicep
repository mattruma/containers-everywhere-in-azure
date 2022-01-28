param appName string
param environment string
param location string
param containerRegistryName string
param imageName string
param storageAccountName string
param logAnalyticsWorkspaceName string
param appInsightsName string
param serverAciName string

var longName = '${appName}-${location}-${environment}'

module aciDeployment 'aci.bicep' = {
  name: 'aciDeployment'
  params: {
    containerRegistryName: containerRegistryName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    longName: longName
    storageAccountName: storageAccountName
    imageName: imageName
    appInsightsName: appInsightsName
    serverAciName: serverAciName
  }
}

output clientAciName string = aciDeployment.outputs.aciName
output clientAciIpAddress string = aciDeployment.outputs.aciIpAddress
