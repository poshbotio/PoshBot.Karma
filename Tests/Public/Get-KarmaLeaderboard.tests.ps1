$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$common = Join-Path (Split-Path -Parent $here) 'Common.ps1'
. $common

InModuleScope PoshBot.Karma {
    Function New-MockKarma {
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

    describe 'Get-KarmaLeaderboard' {
        Context "Given no previous karama" {
            Mock Get-PoshBotStatefulData { $null } -ParameterFilter { $Name -eq 'KarmaState' }
            Mock New-PoshBotTextResponse { }

            Get-KarmaLeaderboard
 
            it 'should invoke a PoshBotRespone that is not cool' {
                Assert-MockCalled New-PoshBotTextResponse -ParameterFilter { $Text -match 'not cool' }
            }
        }

        Context "Given karama for 8 people" {
            Mock Get-PoshBotStatefulData { New-MockKarma } -ParameterFilter { $Name -eq 'KarmaState' }
            Mock New-PoshBotTextResponse { }
            
            describe 'Top of leaderboard' {
                Get-KarmaLeaderboard

                it 'should respond with a user with the most karma' {
                    Assert-MockCalled New-PoshBotTextResponse -ParameterFilter { $Text -match 'UserOne' } -Times 1
                }
            }
        
            describe 'Specify list length' {
                Get-KarmaLeaderboard -Top 5

                it 'should respond with only the top number of users specified' {
                    # Should only see UserFive, not six as the list is limited to top 5
                    Assert-MockCalled New-PoshBotTextResponse -ParameterFilter { $Text -match 'UserFive' -and -not($Text -match 'UserSix') }
                }
            }
        }
    }
}
