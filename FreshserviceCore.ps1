
function Get-Freshservice
{
    <#
        .SYNOPSIS
            Handles Freshservice GET requests, can use basic caching.
        .EXAMPLE
            Get-Freshservice -path /api/v2/requesters -cached

            Get '/api/v2/requesters' via cache
        .LINK
            https://api.freshservice.com
        .NOTES
            Version:        1.0
            Author:         Matthew Nutter
            Creation Date:  20/01/19
    #>
    [CmdletBinding()]
    param (
        # (Mandatory) Path to endpoint e.g. '/api/v2/requesters'
        [parameter(Mandatory = $true)]
        [string]$path,
        # used to enable conversion from json to PSObject
        [switch]$convert,
        # Enables cache. Passed to Invoke-FreshserviceWebRequest
        [switch]$cached,
        # Can be set in config.json file. Format: 'https://subdomain.freshservice.com'
        [string]$domain = $config.domain
    )
    if ($domain -ne $null)
    {
        $url = $domain + $path
    }
    else
    {
        throw "Domain is null"
    }

    $response = Invoke-FreshserviceWebRequest -url $url -cached:$cached

    if ($convert -eq $true)
    {
        $response = $response | ConvertFrom-Json
    }

    return $response
}

function Get-FreshservicePaginated
{
    [CmdletBinding()]
    param(
        # (mandatory) api path e.g. /api/v2/requesters (passed to invoke)
        [Parameter(Mandatory = $true)]
        [string]$path,

        # Passed to Invoke func
        [switch]$cached,

        # Passed to invoke func
        [switch]$flush, # TODO????

        # api version (default:2)
        [int]$api = 2, # TODO: could probably auto detect default here from path

        # page to start reading from during pagination (default:1)
        [int]$start_page = 1,

        # how many items to display per page, v2 api only (default:100)
        [int]$per_page = 100,

        [string]$domain = $config.domain,
        # max concurrent page requests
        [int]$concurrent = 5,
        # api key
        [string]$api_key = $config.api_key,

        [switch]$async
    )

    $range_start = $start_page
    $range_end = $concurrent

    do
    {
        $range = $range_start..$range_end

        $url_array = $range | ForEach-Object {
            "$($domain)$($path)?per_page=$per_page&page=$_"
        }

        if ($async -eq $true)
        {
            Write-Progress -Activity "Paginating $path async using V$API API" -Status "$($pg_result.Length) pages loaded, loading pages $range (max concurrent: $concurrent)"

        }
        else {
            Write-Progress -Activity "Paginating $path using V$API API" -Status "$($pg_result.Length) pages loaded"
        }

        $result = Invoke-FreshserviceMultipleWebRequests $url_array -api_key $api_key -cached:$cached -async:$async

        switch ($api)
        {
            1
            {
                if ( $PSBoundParameters.ContainsKey("per_page"))
                {
                    Write-Error "V1 API does not support changing results per page, generally returns 30" -Category InvalidArgument
                }
                $while = ($null -ne ($result | Where-Object {$null -eq $_.Content}))
            }
            2
            {
                $while = ($null -eq ( $result | Where-Object {$null -eq $_.Headers.Link}))
            }
            Default
            {
                throw "Please specify api version 1 or 2 for pagination"
            }
        }

        $range_start += $concurrent
        $range_end += $concurrent
        $pg_result += $result
    } while ($while)

    get-rsjob | remove-rsjob # clear all runspace jobs

    $pg_result = $pg_result | ConvertFrom-Json

    if ($api -eq 2)
    {
        $pg_result = Read-SingleProperty $pg_result
    }
    elseif ($api -eq 1)
    {
        $pg_result = $pg_result | ForEach-Object { $_ } # convert to array of objects
    }

    Write-Verbose "$($pg_result.Length) Objects Returned"

    return $pg_result
}

function Invoke-FreshserviceRestMethod
{
    param (
        #validate
        [string]$method,

        [string]$url,

        [string]$api_key,
        #if put or post
        [string]$content
    )
}

function Update-Freshservice
{
    # PUT
}

function New-Freshservice
{
    # POST
}

function Remove-Freshservice
{
    # DELETE
}

function Invoke-FreshserviceWebRequest
{
    <#
    .SYNOPSIS
        Handles web requests for Freshservice with basic caching
    .DESCRIPTION
        Long description
    .EXAMPLE
        PS C:\> Invoke-FreshserviceWebRequest -url https://x.freshervice.com/api/v2/x/123 -cached
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
        [string]$url,

        [switch]$cached,

        [switch]$flush,

        [string]$api_key = $config.api_key
    )

    # connection

    $EncodedCredentials = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $api_key, $null)))
    $HTTPHeaders = @{}
    $HTTPHeaders.Add('Authorization', ("Basic {0}" -f $EncodedCredentials))
    $HTTPHeaders.Add('Content-Type', 'application/json')
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

    if ($flush)
    {
        Clear-Cache -url $url
    }

    if ($cached -eq $true)
    {
        $response = Read-Cache -url $url

    }
    if ($null -eq $local:response)
    { # if cache hasn't already assigned a value

        try
        {
            $response = Invoke-WebRequest -Uri $url -Headers $HTTPHeaders -ErrorAction Stop
        }
        catch
        {
            write-error "Error with Invoke-WebRequest function - $($global:Error[0].Exception.Message)"
            $url
            $api_key
            break
        }

        if ($cached -eq $true)
        {
            Write-Cache -url $url -data $response
        }
        Read-RateLimit -response $response
    }
    return $response
}

function Invoke-FreshserviceMultipleWebRequests
{
    # async get requests using poshrsjob
    [CmdletBinding()]
    param (
        [array]$url_array,
        [string]$api_key = $config.api_key,
        [switch]$cached,
        [switch]$async
    )
    if ($async -eq $false)
    {
        $result = $url_array | ForEach-Object {Invoke-FreshserviceWebRequest $_ -cached:$cached -api_key $api_key -ErrorAction Stop}
        return $result
    }
    else
    {
        return $url_array | Start-RSJob -name {$_} -VariablesToImport @('api_key', 'config', 'VerbosePreference', 'cache_storage', 'cached') -ErrorAction Stop -ScriptBlock {
            Invoke-FreshserviceWebRequest $_ -api_key $api_key -cached:$cached -ErrorAction Stop
        } -FunctionsToImport @('Invoke-FreshserviceWebRequest', 'Read-RateLimit', 'Read-Cache', 'Write-Cache') | Wait-RSJob | Receive-RSJob
    }
}
