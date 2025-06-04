param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName
)

# Retrieve the list of resources in the specified resource group.
$resources = az resource list --resource-group $ResourceGroupName | ConvertFrom-Json

# Create a collection of objects with desired properties.
$results = $resources | ForEach-Object {
    [PSCustomObject]@{
        resourceType = $_.type
        resourceName = $_.name
        resourceID   = $_.id
    }
}

# Export the collection to a CSV file with the specified header.
$results | Export-Csv -Path "../data/resourceID.csv" -NoTypeInformation

Write-Host "Resource details have been saved to resourceID.csv"