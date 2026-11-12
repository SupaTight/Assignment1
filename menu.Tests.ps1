
# To Do: Change this
. "$PSScriptRoot\OS_Info_Tristan_McMaster.ps1"

Describe "getClientComputerInformation" {
    BeforeAll {
        Mock Get-ComputerInfo {
            return @{ OsName = 'Windows 11' }
        }
    }

    It "Returns computer property when valid parameter provided" {
		# To Do: Change <getClientComputerInformation> to the name of your function  
        $result = Get-CompInfo -Property 'OsName'
        $result | Should -Not -BeNullOrEmpty
    }

    It "Calls Get-ComputerInfo with correct property" {
		# To Do: Change <getClientComputerInformation> to the name of your function  
        Get-CompInfo -Property 'OsName'
        Assert-MockCalled Get-ComputerInfo -ParameterFilter { $Property -eq 'OsName' } -Times 1
    }

    It "Returns error when exception occurs" {
        Mock Get-ComputerInfo { throw 'Failure' }
		# To Do: Change <getClientComputerInformation> to the name of your function  
        $result = Get-CompInfo -Property 'OsName'
        $result | Should -Match 'Error:'
    }
}

Describe "getAllClientsComputerInformation" {
    BeforeAll {
        Mock Get-ComputerInfo {
            return @{ OsName = 'Windows 11'; OsArchitecture = '64-bit' }
        }
    }

    It "Returns formatted computer information" {
		# To Do: Change <getClientComputerInformation> to the name of your function  
        $result = Get-CompInfo
        $result | Should -Not -BeNullOrEmpty
    }

    It "Calls Get-ComputerInfo once" {
		# To Do: Change <getClientComputerInformation> to the name of your function  
        Get-CompInfo
        Assert-MockCalled Get-ComputerInfo -Times 1
    }

    It "Returns error string on failure" {
        Mock Get-ComputerInfo { throw 'Failure' }
		# To Do: Change <getClientComputerInformation> to the name of your function  
        $result = Get-CompInfo
        $result | Should -Match 'Error:'
    }
}

Describe "ShowMenu" {
    It "Displays menu options" {
        Mock Write-Output {}
		# To Do: Change <ShowMenu> to the name of your function  
        ShowMenu
        Assert-MockCalled Write-Output -Times 10
    }
}

Describe "mainFunction" {
    BeforeEach {
		# To Do: Change <ShowMenu> to the name of your function 
        Mock ShowMenu {}
        Mock Write-Output {}
        Mock Write-Host {}
		# To Do: Change <getClientComputerInformation> to the name of your function  
        Mock Get-CompInfo { return 'MockedValue' }
		# To Do: Change <getClientComputerInformation> to the name of your function  
        Mock Get-CompInfo { return 'AllInfo' }
    }

    Context "Valid selections" {
        It "Handles option 1" {
            Mock Read-Host { return '1' }
			# To Do: Change <mainFunction> to the name of your function  
            mainFunction
			# To Do: Change <getClientComputerInformation> to the name of your function  
            Assert-MockCalled Get-CompInfo -Times 1
        }

        It "Handles option 8" {
            Mock Read-Host { return '8' }
			# To Do: Change <mainFunction> to the name of your function 
            mainFunction
			# To Do: Change <getAllClientsComputerInformation> to the name of your function 
            Assert-MockCalled GetAllCompInfo -Times 1
        }
    }

    Context "Invalid selection greater than 8" {
        It "Prompts again on invalid high input" {
            $calls = 0
            Mock Read-Host {
                $calls++
                if ($calls -eq 1) { return '10' } else { return '9' }
            }
			# To Do: Change <mainFunction> to the name of your function 
            mainFunction
            Assert-MockCalled ShowMenu -Times 2
        }
    }

    Context "Exit condition" {
        It "Exits when user selects 9" {
            Mock Read-Host { return '9' }
			# To Do: Change <mainFunction> to the name of your function 
            { mainFunction } | Should -Not -Throw
        }
    }
}
