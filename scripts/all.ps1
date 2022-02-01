param(
    [ValidatePattern('^[a-zA-Z0-9]+$')]
    [Parameter(Mandatory = $true)] 
    [String] $ProductId,
    [String] $SubscriptionId,
    [String] $Location = "eastus",
    [String] $TemplateFile = './scripts/app-service.bicep'
)

if ($ProductId.Trim() -eq "" ) { 
    throw "'ProductId' is required, please provide a value for '-ProductId' argument."
}

if ($SubscriptionId.Trim() -eq "" ) { 
    throw "'SubscriptionId' is required, please provide a value for '-SubscriptionId' argument."
}

.\scripts\shared.ps1 -ProductId $ProductId -SubscriptionId $SubscriptionId
.\scripts\app-service.ps1 -ProductId $ProductId -SubscriptionId $SubscriptionId
.\scripts\app-service-container.ps1 -ProductId $ProductId -SubscriptionId $SubscriptionId
.\scripts\aci.ps1 -ProductId $ProductId -SubscriptionId $SubscriptionId