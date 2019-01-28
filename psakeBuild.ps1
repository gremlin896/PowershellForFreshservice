properties {
  $script = "$PSScriptRoot\PowershellForFreshservice.psm1"
}

# Default task includes Analyzing and Testing of script
task default -depends Analyze, Test

# Analyze by running Invoke-ScriptAnalyzer. Check script against best known practices
task Analyze {
  $saResults = Invoke-ScriptAnalyzer -Path $script -Severity @('Error', 'Warning') -Recurse -Verbose:$false
  if ($saResults) {
    $saResults | Format-Table
    Write-Error -Message 'One or more Script Analyzer errors/warnings where found. Build cannot continue!'
  }
}

# Run our test to make sure everything is in line
task Test {
  $testResults = Invoke-Pester -Path $PSScriptRoot -PassThru
  if ($testResults.FailedCount -gt 0) {
    $testResults | Format-List
    Write-Error -Message 'One or more Pester tests failed. Build cannot continue!'
  }
}

task Coverage {
  $coResults = invoke-pester $PSScriptRoot -CodeCoverage $script -PassThru
  if ($coResults.CodeCoverage.NumberOfCommandsMissed -gt 0){
    $coResults.CodeCoverage | Format-List
    Write-Error -Message 'Code Coverage not 100%'
  }
}

# Run a deployment script after appropriate tests are passed
task Deploy -depends Analyze, Test {
  Invoke-PSDeploy -Path ".\PowershellForFreshservice.psdeploy.ps1" -Force -Verbose:$VerbosePreference
}
