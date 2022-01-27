param longName string

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: 'asp-${longName}'
  location: resourceGroup().location
  sku: {
    name: 'B1'
    tier: 'Basic'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

output appServicePlanName string = appServicePlan.name
