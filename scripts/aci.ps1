param(
    [ValidatePattern('^[a-zA-Z0-9]+$')]
    [Parameter(Mandatory = $true)] 
    [String] $ProductId,
    [String] $SubscriptionId,
    [String] $Location = "eastus",
    [String] $TemplateFile = './scripts/aci.bicep'
)

if ($ProductId.Trim() -eq "" ) { 
    throw "'ProductId' is required, please provide a value for '-ProductId' argument."
}

$ResourceGroupName = "$($ProductId)rg"

az group create -n $ResourceGroupName -l $Location --subscription $SubscriptionId

az deployment group create `
    -f $TemplateFile `
    -g $ResourceGroupName `
    --subscription $SubscriptionId `
    --parameters productId=$ProductId

$Acr = (az acr show --name mjrbgnacr --subscription $SubscriptionId) | ConvertFrom-Json

$ServerApp = (az container show --name "$($ProductId)aciapi" --resource-group $ResourceGroupName --subscription $SubscriptionId) | ConvertFrom-Json

az role assignment create --assignee-object-id $ServerApp.identity.principalId --assignee-principal-type "ServicePrincipal" --scope $Acr.id --role acrpull