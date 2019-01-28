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

function Update-FreshserviceRequester {}

function New-FreshserviceRequester {}

function Remove-FreshserviceRequester {}

function Get-FreshserviceRequester {}

function Get-FreshserviceRequesterFields {}
