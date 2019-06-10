function Get-FreshserviceAgents {
  # GET /api/v2/agents
  param (
    [switch]$cached
  )
  $response = Get-FreshservicePaginated -path '/api/v2/agents' -api 2 -cached:$cached
  return $response
}

function Update-FreshserviceAgent {
  # PUT /api/v2/agents/[id]
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [int64]$id,
    [boolean]$occaisional,
    [string]$email,
    [int64]$reporting_manager_id,
    [string]$time_zone,
    [string]$language,
    [int64]$location_id,
    [int]$scoreboard_level_id,
    [int64[]]$group_ids,
    [int64[]]$role_ids,
    [string]$signature
  )
  $body = @{
    occaisional = $occaisional
    email = $email
    reporting_manager_id = $reporting_manager_id
    time_zone = $time_zone
    language = $language
    location_id = $location_id
    scoreboard_level_id = $scoreboard_level_id
    group_ids = $group_ids
    role_ids = $role_ids
    signature = $signature
  }
  ($body.GetEnumerator() | Where-Object { -not $_.Value }) | ForEach-Object { $body.Remove($_.Name) } # remove empty values from hashtable TODO: move to helper function
  $body = $body | ConvertTo-Json
  $path = '/api/v2/agents/' + $id
  Invoke-FreshserviceRestMethod -Method PUT -Path $path -Body $body
}
