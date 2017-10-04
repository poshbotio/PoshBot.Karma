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

    $testUsername = 'TestUser'
    describe 'Set-Karma' {
        Context "Given no previous karama" {
            Mock Get-PoshBotStatefulData { $null } -ParameterFilter { $Name -eq 'KarmaState' }
            Mock Set-PoshBotStatefulData { }
            describe 'Adding fresh karma' {
                $result = Set-Karma -User $testUsername

                it 'should return the current karama level' {
                    $result | Should Match "1 karma"
                }

                it 'should return the username with an ampersand' {
                    $result | Should Match ('@' + $testUsername)
                }

                it 'should save the new karama state' {
                    Assert-MockCalled Set-PoshBotStatefulData -ParameterFilter {
                        $Name -eq 'KarmaState' `
                        -and $Value[0].Name -eq $testUsername `
                        -and $Value[0].CurrentKarma -eq 1
                    }
                }
            }
        }

        Context "Given karama for 8 people" {
            $testUsername = 'UserFour'
            Mock Get-PoshBotStatefulData { New-MockKarma } -ParameterFilter { $Name -eq 'KarmaState' }
            Mock Set-PoshBotStatefulData { }
            describe 'Adding additional karma' {
                $result = Set-Karma -User $testUsername

                it 'should return the current karama level' {
                    $result | Should Match "91 karma"
                }

                it 'should return the username with an ampersand' {
                    $result | Should Match ('@' + $testUsername)
                }

                it 'should save the new karama state' {
                    Assert-MockCalled Set-PoshBotStatefulData -ParameterFilter {
                        if ($Name -ne 'KarmaState') { return $false }

                        $found = $false
                        $Value | % { 
                            $found = $found -or (
                                $_.Name -eq $testUsername -and $_.CurrentKarma -eq 91
                            )
                        }
                        
                        return $found
                    }
                }

                it 'should not modify other karma' {
                    $originalKarma = @{}
                    New-MockKarma | % { 
                        $originalKarma[$_.Name] = $_.CurrentKarma
                    }

                    Assert-MockCalled Set-PoshBotStatefulData -ParameterFilter {
                        if ($Name -ne 'KarmaState') { return $false }

                        $allOk = $true
                        $Value | % { 
                            $allOk = $allOk -and (
                                $_.Name -eq $testUsername -or $_.CurrentKarma -eq $originalKarma[$_.Name]
                            )
                        }
                        
                        return $allOk
                    }
                }
            }
        }
    }
}
