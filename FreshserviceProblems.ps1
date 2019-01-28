function Get-FreshserviceProblems
{
    [CmdletBinding()]
    param (
        [switch]$cached,
        [switch]$async
    )
    $response = Get-FreshservicePaginated -path '/itil/problems/filter/all.json' -api 1 -cached:$cached -async:$async

    return $response
}
