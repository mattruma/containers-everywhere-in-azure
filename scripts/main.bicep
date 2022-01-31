param productId string

module shared 'shared.bicep' = {
  name: 'shared'
  params: {
    productId: productId
  }
}

module appService 'app-service.bicep' = {
  name: 'appService'
  params: {
    productId: productId
  }
}

module appServiceContainer 'app-service-container.bicep' = {
  name: 'appServiceContainer'
  params: {
    productId: productId
  }
}
