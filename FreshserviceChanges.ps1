function Get-FreshserviceChanges
{
    [CmdletBinding()]
    param (
        [switch]$cached,

        [switch]$async
    )
    $response = Get-FreshservicePaginated -path '/itil/changes/filter/all.json' -api 1 -cached:$cached -async:$async
    return $response
}
