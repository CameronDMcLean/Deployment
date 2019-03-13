<#
 Script Name: Join_Domain.ps1
 Created by Cameron McLean for personal use

 Script to join domain & set computer description to username used to join, date of joining & computer manufacturer

 Note - winRM must be running for get-computerinfo to work, start with winrm quickconfig

 To-Do:  
  -Check if current description starts with underscore, so it's not overwritten if set manually

#>

#Declare variables
$Credential = ""
$Hostname = $env:computername
$ComputerDescription = ""
$Notes = ""

Write-host "Hostname is $hostname"
$credential = Get-credential -Message "Enter credentials to join to AD"
$Notes = Read-Host "Enter optional notes for description field: "


if(computer exists in AD){
    Write-host "$hostname found in AD, removing."
    Get-ADObject -Filter 'name -eq LABWSJUMPBOX01 -and objectclass -eq Computer' #-Credential $credential
    
    Remove-ADObject -Identity $hostname -credential $credential

}
#Join computer to domain
Add-Computer –domainname labds.cammclean.me -Credential $credential 

Write-Host "Computer added to domain."

Write-host "Setting computer description..."

#Build description string & show
#BIOSSerialNumber is misspelled, that's how it is in the source.
$ComputerDescription = "Computer joined by: " + $Credential.username + " Date: " + (get-date -format yyyy-MM-dd) + " Manufacturer: " + (Get-ComputerInfo).csmanufacturer + " Serial number:" + (Get-ComputerInfo).biosseralnumber + " notes: " + $Notes
Write-host "Description will be set to $computerdescription"

Set-ADComputer -description $ComputerDescription

Write-Host "Computer description set. Script finished."