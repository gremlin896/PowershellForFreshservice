function Get-FreshserviceRequesters
{
    [CmdletBinding()]
    param (
        [switch]$cached,
        [switch]$async
    )
    $response = Get-FreshservicePaginated -path '/api/v2/requesters' -api 2 -cached:$cached -async:$async

    return $response
}

function Update-FreshserviceRequester {
    param (
        [int64]$id,  #todo : make mandatory
        [string]$first_name,
        [string]$last_name,
        [string]$location_id,
        [string]$job_title
    )
    $body = @{
        first_name = $first_name
        last_name = $last_name
        location_id = $location_id
        job_title = $job_title
    }
    ($body.GetEnumerator() | Where-Object { -not $_.Value }) | ForEach-Object { $body.Remove($_.Name) } # remove empty values from hashtable
    $body = $body | ConvertTo-Json
    $path = '/api/v2/requesters/' + $id
    Invoke-FreshserviceRestMethod -Method PUT -Path $path -Body $body
}

function New-FreshserviceRequester {}

function Remove-FreshserviceRequester {}

function Get-FreshserviceRequester {}

function Get-FreshserviceRequesterFields {}
