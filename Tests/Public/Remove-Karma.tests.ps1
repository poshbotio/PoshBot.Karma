$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$common = Join-Path (Split-Path -Parent $here) 'Common.ps1'
. $common

InModuleScope PoshBot.Karma {

    $testUser = 'UserOne'

    describe 'Remove-Karma' {
        Context 'Decrements karma' {
            Mock Set-Karma { }
            Mock New-PoshBotTextResponse {}

            Remove-Karma -Arguments @('', $testUser)

            it 'Should decrement karma by 1' {
                Assert-MockCalled Set-Karma -ParameterFilter {
                    $Subject -eq $testUser -and
                    $Karma -eq -1
                }
            }

            it 'Responds with a message' {
                Assert-MockCalled New-PoshBotTextResponse
            }
        }
    }
}
