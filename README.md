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
az account set --subscription "{SUBSCRIPTION_ID}"

az group create -n "{RESOURCE_GROUP_NAME}" -l "{LOCATION}"
```

1. Create a Service Principal

See <https://docs.microsoft.com/en-us/dotnet/architecture/devops-for-aspnet-developers/actions-deploy#create-an-spn> for more information.

```bash
az ad sp create-for-rbac --name "{SERVICE_PRINCIPAL_NAME}" --sdk-auth --role contributor \
--scopes "/subscriptions/{SUBSCRIPTION_ID}/resourceGroups/{RESOURCE_GROUP_NAME}"
```

```json
{
  "clientId": "",
  "clientSecret": "",
  "subscriptionId": "",
  "tenantId": "",
  ...
}
```

Copy the output, this will be the value used for the GitHub secret `AZURE_CREDENTIALS`.

1. Add GitHub Secrets

Add the following GitHub secrets:

* `AZURE_SUBSCRIPTION_ID` Your Azure Subscription ID
* `AZURE_CREDENTIALS` The output from the Create Service Principal step
* `ENV_FILE` The name of that holds the environment variables, e.g. `.github/workflows/.env`

You can do this in the GitHub Portal or with the GitHub CLI, see <https://docs.github.com/en/github-cli/github-cli>.

```bash
gh auth login

gh secret set AZURE_CREDENTIALS < AZURE_CREDENTIALS.json
gh secret set AZURE_SUBSCRIPTION_ID --body "2164386e-942c-4314-b71e-d4dc327856c5" --repo "mattruma/containers-everywhere-in-azure.git"
```

For more information on adding secrets see <https://cli.github.com/manual/gh_secret_set>.

1. Update `.env` File

Provide names for the Azure resources that will be created.

```text
BASE_RESOURCE_GROUP_NAME=
BASE_ACR_NAME=
BASE_ACR_SERVER_IMAGE_NAME=
BASE_ACR_CLIENT_IMAGE_NAME=
BASE_STORAGE_ACCOUNT_NAME=
BASE_LOG_ANALYTICS_WORKSPACE_NAME=
BASE_APP_SERVICE_PLAN_NAME=
APP_SERVICE_SERVER_NAME=
APP_SERVICE_CLIENT_NAME=
APP_SERVICE_APP_INSIGHTS_NAME=
APP_SERVICE_CONTAINER_SERVER_NAME=
APP_SERVICE_CONTAINER_CLIENT_NAME=
APP_SERVICE_CONTAINER_APP_INSIGHTS_NAME=
ACI_SERVER_NAME=
ACI_CLIENT_NAME=
ACI_SERVER_APP_INSIGHTS_NAME=
ACA_SERVER_NAME=
ACA_CLIENT_NAME=
ACA_SERVER_APP_INSIGHTS_NAME=
AKS_NAME=
AKS_KUBE_ENVIRONMENT_NAME=
```

Save and commit your changes.

1. Deploy Base Infrastructure

From the GitHub Portal, select **Actions** from the Repository screen.

Select the **Deploy Base Infrastructure** workflow and select **Run workflow**.

1. Create GitHub Secret for Azure Container Registry Password

From the Azure Portal, Navigate to the **Azure Container Registry** created in the previous step.

Click **Access Keys**.

Copy one of the displayed passwords.

In the GitHub Portal add secret called `ACR_PASSWORD` and paste in the value copied in the previous step.

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
