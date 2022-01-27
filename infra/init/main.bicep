param appName string
param environment string
param location string

var longName = '${appName}-${location}-${environment}'

module loggingDeployment 'logging.bicep' = {
  name: 'loggingDeployment'
  params: {
    longName: longName
  }
}

module storageDeployment 'storage.bicep' = {
  name: 'storageDeployment'
  params: {
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    longName: longName
  }
}

module containerRegistryDeployment 'acr.bicep' = {
  name: 'containerRegistryDeployment'
  params: {
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    longName: longName
  }
}

module appServicePlanDeployment 'appServicePlan.bicep' = {
  name: 'appServicePlanDeployment'
  params: {
    longName: longName
  }
}

module kubeEnvironmentDeployment 'kubeEnvironment.bicep' = {
  name: 'kubeEnvironmentDeployment'
  params: {
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    longName: longName
  }
}

output storageAccountName string = storageDeployment.outputs.storageAccountName
output containerRegistryName string = containerRegistryDeployment.outputs.containerRegistryName
output logAnalyticsWorkspaceName string = loggingDeployment.outputs.logAnalyticsWorkspaceName
output appInsightsName string = loggingDeployment.outputs.appInsightsName
output appServiceName string = appServicePlanDeployment.outputs.appServicePlanName
output kubeEnvironmentName string = kubeEnvironmentDeployment.outputs.kubeEnvironmentName
