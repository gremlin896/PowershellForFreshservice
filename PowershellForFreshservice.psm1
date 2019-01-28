# This file only exists to enable making this a "Script" module instead of a "Manifest" module
# so that Pester tests are able to use Pester's Mock and InModuleScope features for internal
# methods.  For more information, refer to:
# https://github.com/pester/Pester/wiki/Testing-different-module-types

# GLOBAL VARS

$config = Get-Content -Path "$PSScriptRoot\config.json" -Raw | ConvertFrom-Json

$global:cache_storage = [System.Collections.ArrayList]@() # cache storage array
