
function Debug-Error
{

}

function Import-Config {
    param(
        $path = '.\config.json'
    )
    $script:config = Get-Content -Path $path -Raw | ConvertFrom-Json
}

function Read-SingleProperty
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $response
    )
    #todo validation

        $property = $response | Get-Member -membertype properties | Select-Object -ExpandProperty Name
        if ($property.GetType().Name -eq "String")
        {
            $response = $response | Select-Object -ExpandProperty $property
        }
        else
        {
            throw "Cannot auto expand property, probably more than one"
        }
        return $response
}


function Read-RateLimit
{
    param (
        #
        [Parameter(Mandatory = $true)]
        [PSObject]$response
    )
    $rate_limit = $response.Headers['X-RateLimit-Remaining']
    if ( $null -ne $rate_limit ) # if rate limit header exists
    {
        $message = "$($response.Headers['X-RateLimit-Remaining']) FS V2 API requests remaining"
        if ($rate_limit % 50 -eq 0)
        {
            Write-Warning $message
        }
        else
        {
            Write-Verbose $message
        }
    }
    return
} # end Read-FSRateLimit


function Read-Cache
{
    <#
    .SYNOPSIS
        Reads objects from cache
    .DESCRIPTION
        When URL specified, will only return result if within $cache_time (mins)
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .INPUTS
        Inputs (if any)
    .OUTPUTS
        Output (if any)
    .NOTES
        General notes
    #>
    [CmdletBinding()]
    param (
        # If specified, returns data for url if exists
        [string]$url,

        # cached item life in minutes
        [int]$cache_time = $config.default_cache_time
    )

    $selection = $global:cache_storage | Where-Object url -eq $url

    if ($PSBoundParameters.Count -eq 0)
    {
        return $global:cache_storage | ForEach-Object { [PSCustomObject]$_ } | Format-Table #return/list entire cache (FT)
    }
    elseif ($null -ne $selection) #if cached exists
    {
        # return psobj w/ path, data, timestamp if within or request fresh

        $cutofftime = (Get-Date).AddMinutes(-$cache_time)

        #check timestamp is past currenttime + cache lifetime = $cutoff
        if ($selection.timestamp -lt $cutofftime) # if data.timestamp older than 30mins, flush
        {
            $response = $null
        }
        elseif ($selection.timestamp -ge $cutofftime) # else if younger than 30mins, return cached
        {
            $response = $selection.data
            Write-Verbose "Get (From Cache): $url (timestamp: $($selection.timestamp))"
        }

    }

    elseif ($null -eq $selection)
    {
        # path not found
        $response = $null
    }
    return $response
} # END Read-FSCache

function Clear-Cache
{
    <#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .INPUTS
        Inputs (if any)
    .OUTPUTS
        Output (if any)
    .NOTES
        General notes
    #>
    [CmdletBinding()]
    param (
        # All
        [switch]$all,

        # Single URL
        [string]$url
    )

    if ($all)
    {
        $global:cache_storage = [System.Collections.ArrayList]@() # clear entire cache
        Write-Output "Cleared entire cache"
    }
    elseif ($PSBoundParameters.ContainsKey('url'))
    {
        $selection = $global:cache_storage | Where-Object url -eq $url
        Write-Verbose "Cleared $($selection.url) from cache"
        $global:cache_storage.Remove($selection)
    }
    else {
        throw "Provide an argument for Clear-Cache"
    }
} # END Clear-FSCache

function Write-Cache
{
    param (
        [string]$url,
        [PSObject]$data
    )
    Write-Verbose "Cached: $url"
    [void]$global:cache_storage.Add(@{url = $url; timestamp = Get-Date; data = $data})
}

