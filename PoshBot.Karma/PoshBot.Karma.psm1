
function Set-Karma {
    <#
    .SYNOPSIS
        Give karma to someone
    #>
    [PoshBot.BotCommand(
        CommandName = 'give-karma',
        Aliases = ('karma')
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Scope='Function', Target='*')]
    [cmdletbinding()]
    param(
        [parameter(Mandatory, position = 0)]
        [string]$Subject,

        [parameter(position = 1)]
        [int]$Karma = 1,

        [switch]$Set
    )

    $now = (Get-Date).ToString('u')

    # Some people with @mention people and others just use the username. Normalize it
    $Subject = $Subject.TrimStart('@')

    $karmaState = @(Get-PoshBotStatefulData -Name KarmaState -ValueOnly)
    if (-not $karmaState) {
        $karmaState = @()
    }
    if ($karmaState.Count -ge 1 ) {
        $CurrentKarma = 0
        $subjectKarma = $KarmaState | Where-Object {$_.Name -eq $Subject}
        if ($subjectKarma) {
            if ($Set) {
                [int]$subjectKarma.CurrentKarma = $Karma
            } else {
                [int]$subjectKarma.CurrentKarma += $Karma
            }
            $CurrentKarma = [int]$subjectKarma.CurrentKarma
            $subjectKarma.LastUpdated = $now
        } else {
            $subjectKarma = [pscustomobject]@{
                PSTypeName = 'Karma'
                Name = $Subject
                CurrentKarma = $Karma
                LastUpdated = $now
            }
            $karmaState += $subjectKarma
            $CurrentKarma = $subjectKarma.CurrentKarma
        }
    } else {
        $karmaState = @()
        $item = [pscustomobject]@{
            PSTypeName = 'Karma'
            Name = $Subject
            CurrentKarma = $Karma
            LastUpdated = $now
        }
        $karmaState += $item
        $currentKarma = $Karma
    }

    Set-PoshBotStatefulData -Value $karmaState -Name KarmaState -Depth 10
}

$incrementResponses = @(
    '{0} +1!'
    '{0} gained a level!'
    '{0} is on the rise!'
    '{0} leveled up'
    '{0} is going places!'
)
$decrementResponses = @(
    '{0} took a hit! Ouch.'
    '{0} took a dive.'
    '{0} lost a life.'
    '{0} lost a level.'
)

function Add-Karma {
    [PoshBot.BotCommand(
        Command = $false,
        TriggerType = 'regex',
        Regex = '(\S+[^+:\s])[: ]*\+\+(\s|$)'
    )]
    [cmdletbinding()]
    param(
        [object[]]$Arguments
    )

    $subject = $Arguments[1]
    Set-Karma -Subject $subject -Karma 1
    $text = ($incrementResponses | Get-Random) -f $subject
    New-PoshBotTextResponse -Text $text
}

function Remove-Karma {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Scope='Function', Target='*')]
    [PoshBot.BotCommand(
        Command = $false,
        TriggerType = 'regex',
        Regex = '(\S+[^-:\s])[: ]*--(\s|$)'
    )]
    [cmdletbinding()]
    param(
        [object[]]$Arguments
    )

    $subject = $Arguments[1]
    Set-Karma -Subject $subject -Karma -1
    $text = ($decrementResponses | Get-Random) -f $subject
    New-PoshBotTextResponse -Text $text
}

function Karma {
    [PoshBot.BotCommand()]
    [cmdletbinding()]
    param(
        [string]$Action,

        [string]$Subject,

        [int]$Count = 5
    )

    $karmaState = Get-PoshBotStatefulData -Name KarmaState -ValueOnly

    switch ($Action) {
        {($_ -eq 'Best') -or ([string]::IsNullOrEmpty($_))} {
            $ranking = $karmaState |
                Sort-Object -Property {[int]$_.CurrentKarma} -Descending |
                Select-Object -First $Count -Wait
            $text = ($ranking |
                Select-Object -Property Name, @{l='Karma';e={$_.CurrentKarma}} |
                Format-Table -AutoSize |
                Out-String).Trim()
            New-PoshBotTextResponse -Text $text -AsCode
            break
        }
        'Worst' {
            $ranking = $karmaState |
                Sort-Object -Property {[int]$_.CurrentKarma} |
                Select-Object -First $Count -Wait
            $text = ($ranking |
                Select-Object -Property Name, @{l='Karma';e={$_.CurrentKarma}} |
                Format-Table -AutoSize |
                Out-String).Trim()
            New-PoshBotTextResponse -Text $text -AsCode
            break
        }
        'Empty' {
            if ($Subject) {
                Set-Karma -Subject $subject -Karma 0 -Set
                Write-Output "$Subject karma wiped clean."
            } else {
                Write-Output 'Empty what/who?'
            }
            break
        }
        'wipe' {
            if ($Subject) {
                $karmaState = $karmaState | Where-Object {$_.Name -ne $Subject}
                if (-not $karmaState) {
                    Remove-PoshBotStatefulData -Name KarmaState -Scope Module
                } else {
                    Set-PoshBotStatefulData -Value $karmaState -Name KarmaState -Depth 10
                }
                Write-Output "Karma for $Subject erradicated"
            } else {
                Write-Output 'Wipe what/who?'
            }
        }
    }
}
