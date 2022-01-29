param appInsightsName string
param logAnalyticsWorkspaceName string
param storageAccountName string
param containerRegistryName string
param appServicePlanName string
param kubeEnvironmentName string

module loggingDeployment 'logging.bicep' = {
  name: 'loggingDeployment'
  params: {
    appInsightsName: appInsightsName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
  }
}

module storageDeployment 'storage.bicep' = {
  name: 'storageDeployment'
  params: {
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    storageAccountName: storageAccountName
  }
}

module containerRegistryDeployment 'acr.bicep' = {
  name: 'containerRegistryDeployment'
  params: {
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    containerRegistryName: containerRegistryName
  }
}

module appServicePlanDeployment 'appServicePlan.bicep' = {
  name: 'appServicePlanDeployment'
  params: {
    appServicePlanName: appServicePlanName
  }
}

module kubeEnvironmentDeployment 'kubeEnvironment.bicep' = {
  name: 'kubeEnvironmentDeployment'
  params: {
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    kubeEnvironmentName: kubeEnvironmentName
  }
}
