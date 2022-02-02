param containerInstanceName string
param containerRegistryName string
param imageName string
param storageAccountName string
param logAnalyticsWorkspaceName string
param appInsightsName string
param serverAciName string

module aciDeployment 'aci.bicep' = {
  name: 'clientAciDeployment'
  params: {
    containerRegistryName: containerRegistryName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    containerInstanceName: containerInstanceName
    storageAccountName: storageAccountName
    imageName: imageName
    appInsightsName: appInsightsName
    serverAciName: serverAciName
  }
}

output clientAciIpAddress string = aciDeployment.outputs.aciIpAddress
