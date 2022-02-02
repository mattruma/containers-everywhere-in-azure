# Introduction

BoardGameNerd is site for board gaming enthusiasts to see the current hotness in board games.

## Projects

### BoardGameNerd.Shared

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vestibulum massa id nisl malesuada, ut pretium massa commodo. Duis feugiat accumsan volutpat. Fusce id maximus ligula. Mauris faucibus posuere posuere. Donec eu fringilla turpis. Morbi egestas tellus eu laoreet scelerisque. Curabitur efficitur dolor ut tristique dictum.

### BoardGameNerd.Client

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vestibulum massa id nisl malesuada, ut pretium massa commodo. Duis feugiat accumsan volutpat. Fusce id maximus ligula. Mauris faucibus posuere posuere. Donec eu fringilla turpis. Morbi egestas tellus eu laoreet scelerisque. Curabitur efficitur dolor ut tristique dictum.

### BoardGameNerd.Server

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vestibulum massa id nisl malesuada, ut pretium massa commodo. Duis feugiat accumsan volutpat. Fusce id maximus ligula. Mauris faucibus posuere posuere. Donec eu fringilla turpis. Morbi egestas tellus eu laoreet scelerisque. Curabitur efficitur dolor ut tristique dictum.

## Setup

1. Create a Resource Group

```bash
az group create -n "{RESOURCE_GROUP_NAME}" -l "{LOCATION}" --subscription "{SUBSCRIPTION_ID}"
```

1. Create a Service Principal

See <https://docs.microsoft.com/en-us/dotnet/architecture/devops-for-aspnet-developers/actions-deploy#create-an-spn> for more information.

```bash
az ad sp create-for-rbac --name "{SERVICE_PRINCIPAL_NAME}" --sdk-auth --role contributor \
--scopes "/subscriptions/{SUBSCRIPTION_ID}/resourceGroups/{RESOURCE_GROUP_NAME}"
```

Copy the output, we will need this for the next step.

```json
{
  "clientId": "",
  "clientSecret": "",
  "subscriptionId": "",
  "tenantId": "",
  ...
}
```

1. Add Secrets to GitHub Repository

### App Service

<https://docs.microsoft.com/en-us/dotnet/architecture/devops-for-aspnet-developers/actions-build>

<https://docs.microsoft.com/en-us/dotnet/architecture/devops-for-aspnet-developers/actions-deploy>

### App Service Container

<https://docs.microsoft.com/en-us/azure/container-instances/container-instances-github-action>

```bash
.\src\app-service-container.ps1 -ProductId "YOUR_PRODUCT_NAME"
```

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

1.  Create an environment file ```.github/workflows/.name.env``` to store the names of your resources.

1.  Create a GitHub Secret named ```ENVIRONMENT_FILE``` to store the path to the environment file you wish to use.

1.  Create an ```Azure Resource Group```.

    ```shell
    az group create -g rg-cntnrsEvywr-ussc-demo --location eastus
    ```

1.  Create a GitHub Secret named ```AZURE_CREDENTIALS``` to store the credentials needed to allow the GitHub Action runner to connect & deploy to your Azure subscription. Follow the instructions [here](https://github.com/marketplace/actions/azure-login). Make sure you give the service principal ```Owner``` access since it will try assigning Azure roles on your behalf to the AKS cluster.

1.  Deploy initial infrastructure to Azure using the ```Deploy initial infrastructure for Board Game Nerd``` pipeline.

1.  Create GitHub Secrets ```ACR_USER_NAME``` and ```ACR_PASSWORD``` to store the Azure Container Registry credentials.

1.  Run the ```Server Container Build and Push to Azure Container Registry``` pipeline to build & deploy the ```server``` image & associated Azure services.

1.  Run the ```Client Container Build and Push to Azure Container Registry``` pipeline to build & deploy the ```client``` image & associated Azure services.
