properties {
    $PSBPreference.Build.CompileModule = $true
    $PSBPreference.Help.DefaultLocale  = 'en-US'
}

task default -depends Test

task Pester -FromModule PowerShellBuild -Version '0.4.0'
