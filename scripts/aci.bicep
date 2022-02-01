param productId string

module shared 'shared.bicep' = {
  name: 'shared'
  params: {
    productId: productId
  }
}

resource appContainerInstance 'Microsoft.ContainerInstance/containerGroups@2019-12-01' = {
  name: '${productId}aciapi'
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    containers: [
      {
        name: 'bgnserver'
        properties: {
          image: 'mcr.microsoft.com/appsvc/staticsite:latest'
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 1
            }
          }
          ports: [
            {
              port: 80
            }
            {
              port: 8080
            }
          ]
        }
      }
    ]
    osType: 'Linux'
    ipAddress: {
      type: 'Public'
      dnsNameLabel: '${productId}aciapi'
      ports: [
        {
          protocol: 'TCP'
          port: 80
        }
        {
          protocol: 'TCP'
          port: 8080
        }
      ]
    }
  }
}

// resource apiContainerInstance 'Microsoft.ContainerInstance/containerGroups@2019-12-01' = {
//   name: '${productId}aciapp'
//   location: resourceGroup().location
//   identity: {
//     type: 'SystemAssigned'
//   }
//   properties: {
//     containers: [
//       {
//         name: 'bgnclient'
//         properties: {
//           image: 'mcr.microsoft.com/appsvc/staticsite:latest'
//           resources: {
//             requests: {
//               cpu: 1
//               memoryInGB: 1
//             }
//           }
//           ports: [
//             {
//               protocol: 'TCP'
//               port: 3000
//             }
//           ]
//         }
//       }
//     ]
//     osType: 'Linux'
//   }
// }
