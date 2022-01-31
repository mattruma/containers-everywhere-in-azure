param(
    [ValidatePattern('^[a-zA-Z0-9]+$')]
    [Parameter(Mandatory = $true)] 
    [String] $ProductId,
    [String] $SubscriptionId,
    [String] $Location = "eastus",
    [String] $TemplateFile = './scripts/shared.bicep'
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