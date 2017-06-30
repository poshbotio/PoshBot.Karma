
[cmdletbinding(DefaultParameterSetName = 'task')]
param(
    [parameter(ParameterSetName = 'task')]
    [string[]]$Task = 'default',

    [parameter(ParameterSetName = 'help')]
    [switch]$Help
)

Get-PackageProvider -Name Nuget -ForceBootstrap | Out-Null
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

# Load up dependencies!
if (-not (Get-Module -Name PSDepend -ListAvailable)) {
    Install-Module -Name PSDepend -Repository PSGallery -Confirm:$false -ErrorAction Stop
}
Import-Module PSDepend -Verbose:$false -Force
Invoke-PSDepend -Path $PSScriptRoot\requirements.psd1 -Install -Import -Force

if ($PSBoundParameters.ContainsKey('help')) {
    Get-PSakeScriptTasks -buildFile "$PSScriptRoot\psake.ps1" |
        Format-Table -Property Name, Description, Alias, DependsOn -AutoSize
} else {
    Set-BuildEnvironment -Force

    Invoke-psake -buildFile "$PSScriptRoot\psake.ps1" -taskList $Task -nologo
    exit ( [int]( -not $psake.build_success ) )
}
