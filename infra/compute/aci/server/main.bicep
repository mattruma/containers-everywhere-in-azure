param containerInstanceName string
param containerRegistryName string
param imageName string
param storageAccountName string
param logAnalyticsWorkspaceName string
param appInsightsName string

module aciDeployment 'aci.bicep' = {
  name: 'serverAciDeployment'
  params: {
    containerRegistryName: containerRegistryName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    containerInstanceName: containerInstanceName
    storageAccountName: storageAccountName
    imageName: imageName
    appInsightsName: appInsightsName
  }
}

output serverAciIpAddress string = aciDeployment.outputs.aciIpAddress
