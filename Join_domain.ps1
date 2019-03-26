<#
 Script Name: Join_Domain.ps1
 Created by Cameron McLean for personal use

 Script to join domain & set computer description to username used to join, date of joining & computer manufacturer

 Note - winRM must be running for get-computerinfo to work, perform first time setup with "winrm quickconfig"

 To-Do:  
  -Check if current description starts with underscore, so it's not overwritten if set manually
  -Add logic to save computerinfo to an object so it isn't called twice & check if it returns valid input (wimrm is running)

#>

#Declare variables
$Credential = ""
$Hostname = $env:computername
$ComputerDescription = ""
$Notes = ""
$Result = $false

write-output "Hostname is $hostname"
$credential = Get-credential -Message "Enter credentials to join to AD"
$Notes = Read-Host "Enter optional notes for description field: "


#Check if object exists in AD
Try {Get-ADObject -Filter "Name -like '$Hostname' -and Objectclass -eq 'Computer'" -erroraction stop
    $Result = $true
  }
Catch {
    $Result = $false
  }

if($Result) {
    Write-output "$hostname found in AD, removing."
    Get-ADObject -Filter "Name -like '$Hostname' -and Objectclass -eq 'Computer'" | Remove-ADObject #-Credential $credential
    Write-output "$Hostname removed from AD, new object can be created."

} else {
  Write-output "$Hostname not found in AD, continuing..."
}
#Join computer to domain
Add-Computer -Credential $credential 

write-output "Computer added to domain."

write-output "Setting computer description..."

#Build description string & show
#BIOSSerialNumber is misspelled, that's how it is in the source code.
$ComputerDescription = "Computer joined by: " + $Credential.username + " Date: " + (get-date -format yyyy-MM-dd) + " Manufacturer: " + (Get-ComputerInfo).csmanufacturer + " Serial number:" + (Get-ComputerInfo).biosseralnumber + " notes: " + $Notes
write-output "Description will be set to $computerdescription"

Set-ADComputer -description $ComputerDescription

write-output "Computer description set. Script finished."