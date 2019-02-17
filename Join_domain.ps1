<#
 Script Name: Join_Domain.ps1
 Created by Cameron McLean for personal use

 Script to join domain

 To-Do:  
  -
 -
#>

#Declare variables
$credential = ""
$hostname = $env:computername

Write-host "Hostname is $hostname"
$credential = Get-credential -Message "Enter credentials to join to AD"

if(computer exists in AD){
    Write-host "$hostname found in AD, removing."
    Get-ADObject -Filter 'name -eq LABWSJUMPBOX01 -and objectclass -eq Computer' #-Credential $credential
    
    Remove-ADObject -Identity $hostname -credential $credential

}

Add-Computer –domainname labds.cammclean.me -Credential $credential -restart –force
