
function Get-KarmaLeaderboard {
    [PoshBot.BotCommand(
        CommandName = 'leaderboard'
    )]
    [cmdletbinding()]
    param(
        [int]$Top = 10
    )

    if ($karmaState = Get-PoshBotStatefulData -Name KarmaState -ValueOnly) {
        $leaderboard = $karmaState |
            Sort-Object -Property {[int]$_.CurrentKarma} -Descending |
            Select-Object -First $Top -Wait
        $text = ($leaderboard |
            Select-Object -Property Name, CurrentKarma, LastUpdated |
            Format-Table -AutoSize |
            Out-String).Trim()
        New-PoshBotTextResponse -Text $text -AsCode
    } else {
        New-PoshBotTextResponse -Text 'Not cool. No one has any karma :(' -AsCode
    }
}

function Set-Karma {
    <#
    .SYNOPSIS
        Give karma to someone
    #>
    [PoshBot.BotCommand(
        CommandName = 'give-karma'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Scope='Function', Target='*')]
    [cmdletbinding()]
    param(
        [parameter(Mandatory, position = 0)]
        [string]$User,

        [parameter(position = 1)]
        [int]$Karma = 1
    )

    $now = (Get-Date).ToString('u')

    $karmaState = @(Get-PoshBotStatefulData -Name KarmaState -ValueOnly)
    if (-not $karmaState) {
        $karmaState = @()
    }
    if ($karmaState.Count -ge 1 ) {
        $CurrentKarma = 0
        $userKarma = $KarmaState | Where-Object {$_.Name -eq $User}
        if ($userKarma) {
            [int]$userKarma.CurrentKarma += $Karma
            $CurrentKarma = [int]$userKarma.CurrentKarma
            $userKarma.LastUpdated = $now
        } else {
            $userKarma = [pscustomobject]@{
                PSTypeName = 'Karma'
                Name = $User
                CurrentKarma = $Karma
                LastUpdated = $now
            }
            $karmaState += $userKarma
            $CurrentKarma = $userKarma.CurrentKarma
        }
    } else {
        $karmaState = @()
        $item = [pscustomobject]@{
            PSTypeName = 'Karma'
            Name = $User
            CurrentKarma = $Karma
            LastUpdated = $now
        }
        $karmaState += $item
        $currentKarma = $Karma
    }

    if ($Karma -gt 0) {
        Write-Output "Woot! @$($User) has $CurrentKarma karma"
    } else {
        Write-Output "@$($User) reduced to $currentKarma karma :("
    }

    Set-PoshBotStatefulData -Value $karmaState -Name KarmaState -Depth 10
}

function Reset-Karma {
    <#
    .SYNOPSIS
        Resets the karma state
    #>
    [PoshBot.BotCommand(
        Permissions = 'karma-killer'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Scope='Function', Target='*')]
    [cmdletbinding()]
    param(
        [switch]$Force
    )

    if (-not $Force) {
        New-PoshBotCardResponse -Type Warning -Text 'Are you sure we want to be a karma killer? Use the --force if you do.'
    } else {
        Remove-PoshBotStatefulData -Name KarmaState
        Write-Output 'Karma state wiped clean'
    }
}
