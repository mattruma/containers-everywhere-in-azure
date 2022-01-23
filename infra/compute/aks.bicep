param containerRegistryName string
param longName string
param appName string
param storageAccountName string
param logAnalyticsWorkspaceName string
param managedIdentityName string
param appInsightsName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' existing = {
  name: storageAccountName
}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' existing = {
  name: containerRegistryName
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: managedIdentityName
}

resource aks 'Microsoft.ContainerService/managedClusters@2021-07-01' = {
  name: 'aks-${longName}'
  location: resourceGroup().location
  sku: {
    name: 'Basic'
    tier: 'Free'
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    identityProfile: {
      kubeletidentity: {
        clientId: managedIdentity.properties.clientId
        objectId: managedIdentity.properties.principalId
        resourceId: managedIdentity.id
      }
    }
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 1
        vmSize: 'Standard_DS2_v2'
        osDiskSizeGB: 60
        osDiskType: 'Ephemeral'
        type: 'VirtualMachineScaleSets'
        enableAutoScaling: true
        osType: 'Linux'
        osSKU: 'Ubuntu'
        minCount: 1
        maxCount: 5
        mode: 'System'
      }
    ]
    addonProfiles: {
      azurepolicy: {
        enabled: true
      }
      omsAgent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: logAnalyticsWorkspace.id
        }
      }
    }
    servicePrincipalProfile: {
      clientId: managedIdentity.properties.clientId
    }
    enableRBAC: true
    dnsPrefix: longName
    nodeResourceGroup: 'rg-${appName}-aks'
  }
}

resource aksComputeAgentPool 'Microsoft.ContainerService/managedClusters/agentPools@2021-07-01' = {
  name: '${aks.name}/computepool'
  properties: {
    count: 1
    vmSize: 'Standard_DS3_v2'
    osDiskSizeGB: 60
    osDiskType: 'Ephemeral'
    type: 'VirtualMachineScaleSets'
    minCount: 1
    maxCount: 5
    enableAutoScaling: true
    mode: 'User'
    osType: 'Linux'
    osSKU: 'Ubuntu'
  }
}

output aksName string = aks.name
