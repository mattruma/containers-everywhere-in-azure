param location string = resourceGroup().location
param acrName string
param logWorkspaceName string
param appInsightsName string
param clientAppName string
param clientImageName string
param serverAppName string
param serverImageName string

resource logWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logWorkspaceName
}

resource acr 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' existing = {
  name: acrName
}

resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logWorkspace.id
  }
}

resource serverApp 'Microsoft.ContainerInstance/containerGroups@2021-09-01' = {
  name: serverAppName
  location: location
  properties: {
    sku: 'Standard'
    containers: [
      {
        name: serverAppName
        properties: {
          image: toLower(serverImageName)
          environmentVariables: [
            {
              name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
              value: appInsights.properties.InstrumentationKey
            }
          ]
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 1
            }
          }
          ports: [
            {
              protocol: 'TCP'
              port: 80
            }
          ]
        }
      }
    ]
    osType: 'Linux'
    imageRegistryCredentials: [
      {
        username: acr.listCredentials().username
        server: acr.properties.loginServer
        password: acr.listCredentials().passwords[0].value
      }
    ]
    ipAddress: {
      type: 'Public'
      ports: [
        {
          protocol: 'TCP'
          port: 80
        }
      ]
      dnsNameLabel: serverAppName
    }
  }
}

resource clientApp 'Microsoft.ContainerInstance/containerGroups@2021-09-01' = {
  name: clientAppName
  location: location
  properties: {
    sku: 'Standard'
    containers: [
      {
        name: clientAppName
        properties: {
          image: toLower(clientImageName)
          environmentVariables: [
            {
              name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
              value: appInsights.properties.InstrumentationKey
            }
            {
              name: 'BGN_API_ENDPOINT'
              value: 'http://${serverApp.properties.ipAddress.ip}'
            }
          ]
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 1
            }
          }
          ports: [
            {
              protocol: 'TCP'
              port: 80
            }
          ]
        }
      }
    ]
    osType: 'Linux'
    imageRegistryCredentials: [
      {
        username: acr.listCredentials().username
        server: acr.properties.loginServer
        password: acr.listCredentials().passwords[0].value
      }
    ]
    ipAddress: {
      type: 'Public'
      ports: [
        {
          protocol: 'TCP'
          port: 80
        }
      ]
      dnsNameLabel: clientAppName
    }
  }
}
