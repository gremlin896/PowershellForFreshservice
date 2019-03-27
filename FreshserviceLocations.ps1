function Get-FreshserviceLocations
{
    [CmdletBinding()]
    param (
        [switch]$cached,
        [switch]$async
    )
    $response = Get-FreshservicePaginated -path '/api/v2/locations' -api 2 -cached:$cached -async:$async

    return $response
}

function New-FreshserviceLocation
{
    [CmdletBinding()]
    param (


        [string]$name, #todo:mandatory
        [int64]$parent_location_id,
        [int64]$primary_contact_id,

        [string]$line1,
        [string]$line2,
        [string]$city,
        [string]$state,
        [string]$country,
        [string]$zipcode
    )

    $body = @{
        name = $name
        address = @{
            line1 = $line1
            line2 = $line2
            city = $city
            state = $state
            country = $country
            zipcode = $zipcode
        }
    }
    if ($parent_location_id -ne 0) { $body.Add('parent_location_id', $parent_location_id)}
    if ($primary_contact_id -ne 0) { $body.Add('primary_contact_id', $primary_contact_id)}

    write-host $PSBoundParameters
    $body = $body | ConvertTo-Json



    $path = '/api/v2/locations'
    Invoke-FreshserviceRestMethod -Method POST -Path $path -Body $body
}

function Remove-FreshserviceLocation {
    [CmdletBinding()]
    param (
        [string]$id
    )

    $path = '/api/v2/locations/' + $id
    write-host "Deleted $path"
    Invoke-FreshserviceRestMethod -Method DELETE -Path $path

}
