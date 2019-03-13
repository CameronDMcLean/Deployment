<#
 Script Name: Cleanup_MDT_Computers.ps1
 Created by Cameron McLean for personal use

 Script to clean up & delete MDT test computer objects from AD.

 Pseudocode if necessary:
 Get list of computer objects in AD starting with "MINIT"
 Store retrieved list of objects in $PCs
 Write list of objects to stdout for tech to review, prompt for y/n input
 If y received foreach loop through PCs, delete each & print confirmation message
 If n received cancel & end script
 
 To-Do: 
 -Update $Filter to prompt user / run with passed through input from other scripts
 -Update $Computerlist to only have PCs over x days old (7?)
 -Run automatically every 2 weeks or so
 
#>

#Can edit this for other filters
$Filter = "Name -like 'MININT*'" 
#Resets confirmation to avoid interference from previous runs of the script
$Confirm = "n"
$run = $true

#Get list of objects from AD using provided filter
$ComputerList = Get-ADComputer -Filter $Filter -Properties IPv4Address,Created 

#Display objects & prompt user for confirmation 
Write-Host "Objects to be deleted:"
$ComputerList | Format-Table Name,Created,IPv4Address -A

while ($run) {

	$Confirm = Read-Host "Continue? (y/n)"

	if ($Confirm -eq "y") {
		Write-Host "Removing indicated computer objects from AD"
		foreach ($Computer in $ComputerList) {

			Remove-ADComputer -Identity $Computer -Confirm:$False
			Write-Host $Computer.Name "removed from AD"
		}
		

		Write-Host "All indicated computer objects removed, exiting script"
		$run = $false
	}
	elseif ($Confirm -eq "n"){
		Write-Host "Script cancelled"
		$run = $false
	}

	else {
		Write-Host "Invalid input, enter y or n."

	}

}