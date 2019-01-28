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
