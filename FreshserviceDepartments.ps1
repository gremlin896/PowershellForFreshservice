function Get-FreshserviceDepartments
{
    [CmdletBinding()]
    param (
        [switch]$cached,
        [switch]$async
    )
    $response = Get-FreshservicePaginated -path '/itil/departments.json' -api 1 -cached:$cached -async:$async

    return $response
}
