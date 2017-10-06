$DebugPreference = "SilentlyContinue"

$here = Split-Path -Parent $MyInvocation.MyCommand.Definition
$src = Resolve-Path -Path "$($here)\..\PoshBot.Karma"

# Remove any previously imported module
Get-Module -Name PoshBot.Karma | Remove-Module -Force -Confirm:$false
# Import the PSD1
Import-Module (Join-Path $src 'PoshBot.Karma.psd1')
