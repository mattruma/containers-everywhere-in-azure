param appName string
param environment string
param location string
param containerRegistryName string
param imageName string
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
    imageName: imageName
    appInsightsName: appInsightsName
  }
}

output serverAciName string = aciDeployment.outputs.aciApiName
output serverAciIpAddress string = aciDeployment.outputs.aciApiIpAddress
