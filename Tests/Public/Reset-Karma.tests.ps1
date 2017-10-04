$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$common = Join-Path (Split-Path -Parent $here) 'Common.ps1'
. $common

InModuleScope PoshBot.Karma {
    describe 'Reset-Karma' {

        describe 'Without Force specified' {
            Mock New-PoshBotCardResponse { }
            Mock Remove-PoshBotStatefulData { } -ParameterFilter { $Name -eq 'KarmaState' }

            Reset-Karma

            it 'should invoke a Card Response' {
                Assert-MockCalled New-PoshBotCardResponse -Times 1
            }

            it 'should not invoke Remove-PoshBotStatefulData' {
                Assert-MockCalled Remove-PoshBotStatefulData -Times 0
            }
        }

        describe 'With Force specified' {
            Mock New-PoshBotCardResponse { }
            Mock Remove-PoshBotStatefulData { } -ParameterFilter { $Name -eq 'KarmaState' }

            Reset-Karma -Force

            it 'should not invoke a Card Response' {
                Assert-MockCalled New-PoshBotCardResponse -Times 0
            }

            it 'should invoke Remove-PoshBotStatefulData' {
                Assert-MockCalled Remove-PoshBotStatefulData -Times 1
            }
        }
    }
}
