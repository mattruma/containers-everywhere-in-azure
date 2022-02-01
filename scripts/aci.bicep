param productId string
param apiImage string = ''
param appImage string = ''

var apiImageName = apiImage == '' ? '${productId}acr.azurecr.io/hello-world:latest' : apiImage
var appImageName = appImage == '' ? '${productId}acr.azurecr.io/hello-world:latest' : appImage

module shared 'shared.bicep' = {
  name: 'shared'
  params: {
    productId: productId
  }
}

resource acr 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' existing = {
  name: '${productId}acr'
}

resource apiContainerInstance 'Microsoft.ContainerInstance/containerGroups@2021-09-01' = {
  name: '${productId}aciapi'
  location: resourceGroup().location
  properties: {
    sku: 'Standard'
    containers: [
      {
        name: '${productId}aciapi'
        properties: {
          image: apiImageName
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
      dnsNameLabel: '${productId}aciapi'
    }
  }
}

resource appContainerInstance 'Microsoft.ContainerInstance/containerGroups@2021-09-01' = {
  name: '${productId}aciapp'
  location: resourceGroup().location
  properties: {
    sku: 'Standard'
    containers: [
      {
        name: '${productId}aciapp'
        properties: {
          image: appImageName        
          environmentVariables: [
            {
              name: 'BGN_API_ENDPOINT'
              value: 'http://${apiContainerInstance.properties.ipAddress.ip}'
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
      dnsNameLabel: '${productId}aciapp'
    }
  }
}
