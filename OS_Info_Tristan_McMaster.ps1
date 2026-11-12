<#
    OS Information Gathering Script
    Tristan McMaster_001247213
    ICTNWK428 - Assisgnment 1

#>

mainFunction

#Uses the Get-ComputerInfo command and captures the -Property of the desired information
function Get-CompInfo {
    param(
        [Parameter(Mandatory)]
        [string]$compProp
    )
    #puts the -Property of Get-ComputerInfo command into a variable and returns it
    try {
        $sysinfo = Get-ComputerInfo -Property $compProp
        return $sysinfo.$compProp
    }
    #prints error message if command fails
    catch {
        Write-Host "Error retrieving property '$compProp': $($_.Exception.Message)" -ForegroundColor Red
    }
}
#Uses Get-CompInfo functions to gather specific information on the OS
function Get-SystemInfo {

    param(
        [Parameter(Mandatory)]
        $answer
    )
    
#takes the $answer variable and switchs to the desired command and prints the result       
    try{
        switch ($answer) {
            #Gets Operating SYstem name
            '1'{
                Write-Host "Getting Operating System"
                return (Get-CompInfo "OsName")       
            }
            #Gets Windows remote service status
            '2'{
                Write-Host "Getting Windows remote service status. "
                $winrm = Get-Service -Name WinRM 
                return "WinRM status is:$($winrm.Status)"
            }
            #Gets computers manufacturer and model
            '3'{
                Write-Host "Getting Manufacturer and Model"
                $mfg = Get-CompInfo "CsManufacturer"
                $model = Get-CompInfo "CsModel"
                return "Manufacturer: $mfg | Model: $model"
            }
            #Gets computers name
            '4'{
                Write-Host "Getting Computer Name"
                return (Get-CompInfo "Csname")
            }
            #Gets computers domain name
            '5'{
                Write-Host "Getting Computer Domain Name"
                return (Get-CompInfo "CsDomain")
            }
            #Gets the trusted hosts file and returns all trusted hosts
            '6'{
                Write-Host "Getting Computer's Trusted Hosts"
                $trustedhosts = (Get-Item WSMan:\localhost\Client\TrustedHosts).Value
                if ([string]::IsNullOrEmpty($trustedhosts)){
                    return "No Trusted Hosts Configured"
                }     
        
               return $trustedhosts
            }
            #Gets the computers architecture
            '7'{
                Write-Host "Getting Operating system architecture"
                return (Get-CompInfo "OsArchitecture")
            }
            #combines all above commands and prints out in a list
            '8'{
                GetAllCompInfo
               }
            }       
         
        }
   #if a command above fails the catch command prints out the system given error message to alert the user
    catch {
        $errormessage = $_.Exception.Message
        Write-Host "error has ocurred (reference: $errormessage)"
        return
    }
}


function ShowMenu {
    Write-Host "----------------------------------------------"
    Write-Host "OS Information Menu"
    Write-Host "----------------------------------------------"
    Write-Host "(1)Operating System Currently Being Used"
    Write-Host "(2)Windows Remote Service status"
    Write-Host "(3)Computer Manufacturer and Model"
    Write-Host "(4)Computer Name"
    Write-Host "(5)Computer Domain Name"
    Write-Host "(6)Computer's Trusted Hosts"
    Write-Host "(7)Operating System Architecture (32 or 64 bit)"
    Write-Host "(8)Get all the above information"
    Write-Host "(9) Quit"
    Write-Host "-----------------------------------------------"
}

function mainFunction{
#Set $answer to something that isnt 9 to begin while loop
$answer = ''

#begin while loop
while ($answer -ne '9') {
#Display options for user to choose from
   ShowMenu

#capture users response in a variable 
    $answer = Read-Host "Type a number from 1-9 to select an option"
    Write-Host "-----------------------------------------------"

#check to see if the user wants to quit immediately
    if ($answer -eq '9'){  
        Write-Host " Goodbye!" -ForegroundColor Yellow
        break
    }
    #Checks if the input is Empty, Null or a whitespace
    if ([string]::IsNullOrWhiteSpace($answer)) {
        Write-Host "Input is invalid because it is null or empty. Please enter a number from 1 to 9." -ForegroundColor Red 
        continue 
    }
    #Checks if the input has letters or symbols
    if ($answer -notmatch '^[0-9]+$') {
        Write-Host "Invalid input:'$answer' is invalid because it is not number. Please enter digits only (1-9)." -ForegroundColor Red 
        continue
    }
        #Checks if the input is between numbers 1-9
    if ([int]$answer -gt 9 -or [int]$answer-lt 1){
        Write-Host "Input is invalid because the number you entered is out of range. Please enter digits only (1-9)" -ForegroundColor Red
        continue 
    }

#Call function Get-SystemInfo and give it the users answer
#Save this result into a variable and then write the result to screen
    $result = Get-SystemInfo -answer $answer
    Write-Host $result
    Write-Host "-----------------------------------------------"
    continue

    }
}

function GetAllCompInfo{
            
                Write-Host "Gathering all above information"
                $osinfo = Get-ComputerInfo
                $winrm = Get-Service -Name WinRM
                $trustedhosts = (Get-Item WSMan:\localhost\Client\TrustedHosts).Value
            if ([string]::IsNullOrEmpty($trustedhosts)){
                $trustedhosts ="None Configured"
                }
            $OSinfoList = [PSCustomObject]@{
                ComputerName    = $osinfo.CsName 
                Domain          = $osinfo.CsDomain
                Manufacturer    = $osinfo.CsManufacturer
                Model           = $osinfo.CsModel
                OperatingSystem = $osinfo.OsName
                OSArchitecture  = $osinfo.OsArchitecture
                WinRMStatus     = $winrm.Status
                TrustedHosts    = $trustedHosts
                }
                return $($OSinfoList | Format-List | Out-String)         
              
}
