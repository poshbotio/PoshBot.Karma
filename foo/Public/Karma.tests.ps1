$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$common = Join-Path (Split-Path -Parent $here) 'Common.ps1'
. $common

InModuleScope PoshBot.Karma {

    function New-MockKarma {
        Write-Output @(
            [PSCustomObject]@{
                PSTypeName = 'Karma'
                Name = 'UserOne'
                CurrentKarma = 100
                LastUpdated = $now
            },
            [PSCustomObject]@{
                PSTypeName = 'Karma'
                Name = 'UserThree'
                CurrentKarma = 95
                LastUpdated = $now
            },
            [PSCustomObject]@{
                PSTypeName = 'Karma'
                Name = 'UserTwo'
                CurrentKarma = 97
                LastUpdated = $now
            },
            [PSCustomObject]@{
                PSTypeName = 'Karma'
                Name = 'UserFour'
                CurrentKarma = 90
                LastUpdated = $now
            },
            [PSCustomObject]@{
                PSTypeName = 'Karma'
                Name = 'UserSix'
                CurrentKarma = 79
                LastUpdated = $now
            },
            [PSCustomObject]@{
                PSTypeName = 'Karma'
                Name = 'UserEight'
                CurrentKarma = 10
                LastUpdated = $now
            },
            [PSCustomObject]@{
                PSTypeName = 'Karma'
                Name = 'UserFive'
                CurrentKarma = 80
                LastUpdated = $now
            },
            [PSCustomObject]@{
                PSTypeName = 'Karma'
                Name = 'UserSeven'
                CurrentKarma = 50
                LastUpdated = $now
            }
        )
    }

    $NL = [System.Environment]::NewLine

    describe 'Show best karma' {
        Mock Get-PoshBotStatefulData { New-MockKarma } -ParameterFilter { $Name -eq 'KarmaState' }

        $result = karma
        it 'Selects the top karma' {
            $result.PSObject.TypeNames[0] | should -Be 'PoshBot.Text.Response'
            $index1 = $result.Text.IndexOf('UserOne')
            $index2 = $result.Text.IndexOf('UserTwo')
            $index1 -lt $index2 | should -be $true
        }

        $result = karma -Count 3
        it 'Selects top N karma' {
            $result.Text.Split($NL).Count | should be 5
        }
    }

    describe 'Show worst karma' {
        Mock Get-PoshBotStatefulData { New-MockKarma } -ParameterFilter { $Name -eq 'KarmaState' }

        $result = karma
        it 'Selects the bottom karma' {
            $result.PSObject.TypeNames[0] | should -Be 'PoshBot.Text.Response'
            $index1 = $result.Text.IndexOf('UserOne')
            $index2 = $result.Text.IndexOf('UserTwo')
            $index1 -lt $index2 | should -be $true
        }
    }

    describe 'Empty karma' {
        Mock Get-PoshBotStatefulData { New-MockKarma } -ParameterFilter { $Name -eq 'KarmaState' }
        Mock Set-Karma { }

        it 'Removes karma from a thing' {
            $result = karma empty UserOne
            $result | should be 'UserOne karma wiped clean.'
        }
    }

    describe 'Wipe karma' {
        Mock Get-PoshBotStatefulData { New-MockKarma } -ParameterFilter { $Name -eq 'KarmaState' }
        Mock Remove-PoshBotStateFulData { }

        it 'Removes a thing from karma state' {
            Mock Set-PoshBotStatefulData {} -ParameterFilter { $Name -eq 'KarmaState' }
            $result = karma wipe UserOne
            Assert-MockCalled -CommandName Set-PoshBotStatefulData -Times 1 -ParameterFilter { $Name -eq 'KarmaState' }
        }

        it 'Removes karma state when empty' {
            Mock Get-PoshBotStatefulData { Write-Output @() } -ParameterFilter { $Name -eq 'KarmaState' }
            $result = karma wipe UserOne
            Assert-MockCalled -CommandName Remove-PoshBotStateFulData -Times 1 -ParameterFilter { $Name -eq 'KarmaState' }
        }
    }
}
