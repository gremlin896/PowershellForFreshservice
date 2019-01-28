﻿@{

  # Script module or binary module file associated with this manifest.
  RootModule = 'PowershellForFreshservice.psm1'

  # Version number of this module.
  ModuleVersion = '0.1.0'

  # ID used to uniquely identify this module
  GUID = ''

  # Author of this module
  Author = 'Matthew Nutter'

  # Company or vendor of this module
  CompanyName = ''

  # Copyright statement for this module
  Copyright = ''

  # Description of the functionality provided by this module
  Description = 'Powershell wrapper for Freshservice API'

  # Minimum version of the Windows PowerShell engine required by this module
  # PowerShellVersion = '3.0'

  # Processor architecture (None, X86, Amd64) required by this module
  ProcessorArchitecture = 'None'

  # Modules that must be imported into the global environment prior to importing this module
  RequiredModules = @('PoshRSJob')

  # Assemblies that must be loaded prior to importing this module
  # RequiredAssemblies = @()

  # Script files (.ps1) that are run in the caller's environment prior to importing this module.
  # ScriptsToProcess = @()

  # Type files (.ps1xml) to be loaded when importing this module
  # TypesToProcess = @()

  # Format files (.ps1xml) to be loaded when importing this module
  # FormatsToProcess = @()

  # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
  NestedModules = @(
    'FreshserviceAssets.ps1'
    'FreshserviceChanges.ps1',
    'FreshserviceCore.ps1',
    'FreshserviceDepartments.ps1',
    'FreshserviceLocations.ps1',
    'FreshserviceRequesters.ps1',
    'FreshserviceProblems.ps1',

    'Helpers.ps1'
  )

  # Functions to export from this module
  FunctionsToExport = @(
    'Get-Freshservice',
    'Get-FreshservicePaginated',
    'Invoke-FreshserviceWebRequest',
    'Invoke-FreshserviceMultipleWebRequests'
    'Update-Freshservice'

    'Read-SingleProperty',
    'Read-RateLimit',
    'Read-Cache',
    'Write-Cache',
    'Clear-Cache',

    'Get-FreshserviceChanges',

    'Get-FreshserviceDepartments',

    'Get-FreshserviceLocations',

    'Get-FreshserviceRequesters',
    'Update-FreshserviceRequester',
    'New-FreshserviceRequester',
    'Remove-FreshserviceRequester',

    'Get-FreshserviceProblems'

  )

  # Cmdlets to export from this module
  # CmdletsToExport = @()

  # Variables to export from this module
  VariablesToExport = @('Cache_Storage', 'Config')

  # Aliases to export from this module
  # AliasesToExport = @()

  # DSC resources to export from this module
  # DscResourcesToExport = @()

  # List of all modules packaged with this module
  # ModuleList = @()

  # List of all files packaged with this module
  # FileList = @()

  # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
  PrivateData = @{

    PSData = @{

      # Tags applied to this module. These help with module discovery in online galleries.
      Tags = @("PowerShell", "")

      # A URL to the main website for this project.
      ProjectUri = ''

      # A URL to an icon representing this module.
      # IconUri = ''

      # ReleaseNotes of this module
      ReleaseNotes = ''

      # External dependent modules of this module
      # ExternalModuleDependencies = ''

    } # End of PSData hashtable

  } # End of PrivateData hashtable

  # HelpInfo URI of this module
  HelpInfoURI = ''

  # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
  # DefaultCommandPrefix = ''

}
