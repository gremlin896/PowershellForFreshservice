function Get-FreshserviceTickets {
    [CmdletBinding()]
    param (
        [switch]$cached,
        [switch]$async
    )
    $response = Get-FreshservicePaginated -path '/api/v2/tickets' -api 2 -cached:$cached -async:$async

    return $response
}

function New-FreshserviceTicket {
    # /api/v2/tickets POST
}

function Get-FreshserviceTicket {
    # /api/v2/tickets/[id] GET
}

function Update-FreshserviceTicket {
    # /api/v2/tickets/[id] PUT
    param (
        [int64]$id, #todo : make mandatory
        [int64]$group_id,
        $custom_fields,
        $type,
        $description
    )
    $body = @{
        group_id = $group_id
        custom_fields = $custom_fields
        type = $type
        description = $description
    }
    ($body.GetEnumerator() | Where-Object { -not $_.Value }) | ForEach-Object { $body.Remove($_.Name) } # remove empty values from hashtable
    $body = $body | ConvertTo-Json
    write-host $body
    $path = '/api/v2/tickets/' + $id
    Invoke-FreshserviceRestMethod -Method PUT -Path $path -Body $body
}

function Remove-FreshserviceTicket {
    # /api/v2/tickets/[id] DELETE
}

function Restore-FreshserviceTicket {
    # /api/v2/tickets/[id]/restore GET
}

function Get-FreshserviceTicketFields {
    # /api/v2/ticket_fields GET
}
