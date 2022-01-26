# Introduction

BoardGameNerd is site for board gaming enthusiasts to see the current hotness in board games.

## Projects

### BoardGameNerd.Shared

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vestibulum massa id nisl malesuada, ut pretium massa commodo. Duis feugiat accumsan volutpat. Fusce id maximus ligula. Mauris faucibus posuere posuere. Donec eu fringilla turpis. Morbi egestas tellus eu laoreet scelerisque. Curabitur efficitur dolor ut tristique dictum.

### BoardGameNerd.Client

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vestibulum massa id nisl malesuada, ut pretium massa commodo. Duis feugiat accumsan volutpat. Fusce id maximus ligula. Mauris faucibus posuere posuere. Donec eu fringilla turpis. Morbi egestas tellus eu laoreet scelerisque. Curabitur efficitur dolor ut tristique dictum.

### BoardGameNerd.Server

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vestibulum massa id nisl malesuada, ut pretium massa commodo. Duis feugiat accumsan volutpat. Fusce id maximus ligula. Mauris faucibus posuere posuere. Donec eu fringilla turpis. Morbi egestas tellus eu laoreet scelerisque. Curabitur efficitur dolor ut tristique dictum.

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

1.  Build the 2 container images and upload to the `Azure Container Registry`.

    ```shell
    az acr build --image test/aspnet-core-dotnet-core-app:v1 --registry acrcntnrsEvywreastusdemo --file Dockerfile .
    az acr build --image test/aspnet-core-dotnet-core-api:v1 --registry acrcntnrsEvywreastusdemo --file Dockerfile .
    ```

1.  Deploy the ```Azure Container Instance```, ```Azure Container Apps``` & the ```Azure App Service```.

    ```shell
    az deployment group create --resource-group rg-cntnrsEvywr-eastus-demo --template-file ./infra/compute/main.bicep --parameters ./infra/demo.parameters.json --parameters containerRegistryName=acrcntnrsEvywreastusdemo appImageName=acrcntnrsEvywreastusdemo.azurecr.io/test/aspnet-core-dotnet-core-app:v1 apiImageName=acrcntnrsEvywreastusdemo.azurecr.io/test/aspnet-core-dotnet-core-api:v1 storageAccountName=satiuxyuo5j53sy logAnalyticsWorkspaceName=la-cntnrsEvywr-eastus-demo appInsightsName=ai-cntnrsEvywr-eastus-demo
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
    helm install --namespace containers-everywhere --create-namespace --values ./compute/aks/values.yaml --set image.registry=acrcntnrsEvywreastusdemo.azurecr.io --set image.appRepository=test/aspnet-core-dotnet-core-app --set image.apiRepository=test/aspnet-core-dotnet-core-api containers-everywhere ./compute/aks 
    ```