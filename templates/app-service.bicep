param logWorkspaceName string
param appServicePlanName string
param appInsightsName string
param demoAppName string
param clientAppName string
param serverAppName string

resource logWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logWorkspaceName
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' existing = {
  name: appServicePlanName
}

resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: appInsightsName
  location: resourceGroup().location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logWorkspace.id
  }
}

resource clientApp 'microsoft.web/sites@2020-06-01' = {
  name: clientAppName
  location: resourceGroup().location
  kind: 'app'
  properties: {
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|6.0'
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
      ]
    }
    serverFarmId: appServicePlan.id
  }
}

resource serverApp 'microsoft.web/sites@2020-06-01' = {
  name: serverAppName
  location: resourceGroup().location
  kind: 'app'
  properties: {
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|6.0'
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
      ]
    }
    serverFarmId: appServicePlan.id
  }
}

resource demoApp 'microsoft.web/sites@2020-06-01' = {
  name: demoAppName
  location: resourceGroup().location
  kind: 'app'
  properties: {
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|6.0'
      appSettings: [
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
      ]
    }
    serverFarmId: appServicePlan.id
  }
}
