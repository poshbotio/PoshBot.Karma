$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$common = Join-Path (Split-Path -Parent $here) 'Common.ps1'
. $common

InModuleScope PoshBot.Karma {

    $testUser = 'UserOne'

    describe 'Add-Karma' {

        Context "Given karama for 8 people" {
            Context 'Increments karma' {
                Mock Set-Karma { }
                Mock New-PoshBotTextResponse {}

                Add-Karma -Arguments @('', $testUser)

                it 'Should increment karma by 1' {
                    Assert-MockCalled Set-Karma -ParameterFilter {
                        $Subject -eq $testUser -and
                        $Karma -eq 1
                    }
                }

                it 'Responds with a message' {
                    Assert-MockCalled New-PoshBotTextResponse
                }
            }
        }
    }
}
