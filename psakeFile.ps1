properties {
    $PSBPreference.Build.CompileModule = $true
}

task default -depends Test

task Pester -FromModule PowerShellBuild -Version '0.4.0'
