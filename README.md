# Introduction

BoardGameNerd is site for board gaming enthusiasts to see the current hotness in board games.

## Projects

### BoardGameNerd.Shared

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vestibulum massa id nisl malesuada, ut pretium massa commodo. Duis feugiat accumsan volutpat. Fusce id maximus ligula. Mauris faucibus posuere posuere. Donec eu fringilla turpis. Morbi egestas tellus eu laoreet scelerisque. Curabitur efficitur dolor ut tristique dictum.

### BoardGameNerd.Client

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vestibulum massa id nisl malesuada, ut pretium massa commodo. Duis feugiat accumsan volutpat. Fusce id maximus ligula. Mauris faucibus posuere posuere. Donec eu fringilla turpis. Morbi egestas tellus eu laoreet scelerisque. Curabitur efficitur dolor ut tristique dictum.

### BoardGameNerd.Server

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vestibulum massa id nisl malesuada, ut pretium massa commodo. Duis feugiat accumsan volutpat. Fusce id maximus ligula. Mauris faucibus posuere posuere. Donec eu fringilla turpis. Morbi egestas tellus eu laoreet scelerisque. Curabitur efficitur dolor ut tristique dictum.

## Deployment

### Create a Service Principal

See <https://docs.microsoft.com/en-us/dotnet/architecture/devops-for-aspnet-developers/actions-deploy#create-an-spn> for more information.

```bash
az ad sp create-for-rbac --name "{sp-name}" --sdk-auth --role contributor \
--scopes /subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/Microsoft.Web/sites/{webappname}
```

### App Service

<https://docs.microsoft.com/en-us/dotnet/architecture/devops-for-aspnet-developers/actions-build>

<https://docs.microsoft.com/en-us/dotnet/architecture/devops-for-aspnet-developers/actions-deploy>

### App Service Container

<https://docs.microsoft.com/en-us/azure/container-instances/container-instances-github-action>

## Notes

Will deploy to Azure using GitHub Actions.

Will deploy infrastructure using Bicep templates.

Will create the infrastructure prior, but important to share the templates if users want to deploy it to themselves.

Deployment locations include:

- [ ] Azure Container Instances
- [ ] Azure App Services for Containers
- [ ] Azure Kubernetes Services
- [ ] Azure Container Apps

Answer the question why would you use each platform? The pros and cons.

Should be demo intensive.

From the end user perspective, build a rubric/flowchart.

One build pipeline, and then six deployment pipelines.

### Bonus

"DAPRize" AKS and Container Apps ... communication between the front end and the back end.

Thanks to <https://github.com/roberto-mardeni/azure-containers-demo> for the inspiration.

### Deployment

#### Prerequisites

Must have the following dependencies installed

  - [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
  - [Bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#azure-cli)
  - [Helm](https://helm.sh/docs/intro/install/)

#### Instructions

1.  Modify the ```/infra/demo.parameters.json``` file as needed.

1.  Create an ```Azure Resource Group```.

    ```shell
    az group create -g rg-cntnrsEvywr-ussc-demo --location eastus
    ```

1.  Deploy initial infrastructure to Azure.

    ```shell
    az deployment group create --resource-group rg-cntnrsEvywr-eastus-demo --template-file ./infra/init/main.bicep --parameters ./infra/demo.parameters.json
    ```

    This command will output the names of the various resources (Azure Container Registry, Log Analytics, etc). You will need these names in the next steps.

1.  Build the 2 container images and upload to the `Azure Container Registry`. You should run these from the ```/src``` directory

    ```shell
    az acr build --image board-game-nerd-server:latest --registry acrcntnrsEvywreastusdemo --file BoardGameNerd.Server/Dockerfile .
    az acr build --image board-game-nerd-client:latest --registry acrcntnrsEvywreastusdemo --file BoardGameNerd.Client/Dockerfile .
    ```

1.  Deploy the ```Azure Container Instance```, ```Azure Container Apps``` & the ```Azure App Service```.

    ```shell
    az deployment group create --resource-group rg-cntnrsEvywr-eastus-demo --template-file ./infra/compute/main.bicep --parameters ./infra/demo.parameters.json --parameters containerRegistryName=acrcntnrsEvywreastusdemo appImageName=acrcntnrsEvywreastusdemo.azurecr.io/board-game-nerd-client:latest apiImageName=acrcntnrsEvywreastusdemo.azurecr.io/board-game-nerd-server:latest storageAccountName=satiuxyuo5j53sy logAnalyticsWorkspaceName=la-cntnrsEvywr-eastus-demo appInsightsName=ai-cntnrsEvywr-eastus-demo
    ```

1.  Look in the output for various http endpoints.

    ```yaml
    outputs:
    aciApiIpAddress:
      type: String
      value: http://52.224.37.52
    aciAppIpAddress:
      type: String
      value: http://20.121.153.96
    apiServiceHostName:
      type: String
      value: http://as-api-cntnrsevywr-eastus-demo.azurewebsites.net
    appServiceHostName:
      type: String
      value: http://as-app-cntnrsevywr-eastus-demo.azurewebsites.net
    containerAppsApiFqdn:
      type: String
      value: http://ca-api-cntnrsevywr.bravemushroom-3351fa84.eastus.azurecontainerapps.io
    containerAppsAppFqdn:
      type: String
      value: http://ca-app-cntnrsevywr.bravemushroom-3351fa84.eastus.azurecontainerapps.io
    ```

1.  Execute the ```/infra/compute/aks.sh``` file (on Windows, copy the ```az``` command and run manually)

    ```shell
    ./infra/compute/aks.sh -g rg-cntnrsEvywr-eastus-demo -n aks-cntnrsEvywr -c acrcntnrsEvywreastusdemo
    ```

1.  Get the AKS credentials & populate your local ```kubectl``` config file.

    ```shell
    az aks get-credentials --resource-group rg-cntnrsEvywr-eastus-demo --name aks-cntnrsEvywr
    ```

1.  Deploy the ```Helm``` chart that installs the app & api in AKS.

    ```shell
    helm install --namespace containers-everywhere --create-namespace --values ./infra/compute/aks/values.yaml --set image.registry=acrcntnrsEvywreastusdemo.azurecr.io --set image.appRepository=board-game-nerd-client --set image.apiRepository=board-game-nerd-server containers-everywhere ./infra/compute/aks
    ```

1.  Get the IP address of the ingress from AKS.

    ```shell
    kubectl get ingress --namespace containers-everywhere
    ```

    ```shell
    NAME                                CLASS    HOSTS   ADDRESS      PORTS   AGE                                                                                                                    containers-everywhere-app-ingress   <none>   *       20.81.67.6   80      32h
    ```

    Navigate to the IP address indicated (example: http://20.81.67.6)
    