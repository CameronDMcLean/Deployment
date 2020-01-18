<#
 Script Name: Cleanup_AD_Users
 Created by Cameron McLean for personal use

 Script to delete user objects unused for 6 months from AD

 Pseudocode if necessary:
-List computers & prompt  for confirmation
-Write deleted computers to log file
-Output deleted computers
 
 To-Do: 
 -Update $Filter to prompt user / run with passed through input from other scripts
 -Update $Computerlist to only have PCs over x days old (7?)
 -Run automatically every 2 weeks or so
 
#> 
$InactiveDaysInput = ""
$MaxInactiveDays = 180 #Maximum account inactivity, in days
$CurrentDate = (get-date).ToString('MM-dd-yyyy_hh-mm-ss')
$InactiveUsers
$DeleteInput = "N"

$InactiveDaysInput = Read-Host "Enter maximum inactivity period of accounts, or Y to continue with default of $MaxInactiveDays"
if ($InactiveDaysInput -ne "Y" -and $InactiveDaysInput -ne "y"){
    Write-output "Setting maximum inactivity period to $InactiveDaysInput"
    $MaxInactiveDays = $InactiveDaysInput
} else {
    Write-output "Continuing with default 180 days"
}

# $MaxLogonDate = (Get-Date).AddDays(-$MaxInactiveDays) # Not needed, causes errors when used with lastlogondate

$InactiveUsers = get-aduser -filter * -properties * | Where-Object {$_.lastlogondate -lt (get-date).adddays(-$MaxInactiveDays)} | 

Select-Object samaccountname,enabled,distinguishedname,whencreated,passwordlastset,lastlogondate | 

Sort-Object lastlogondate
 
$InactiveUsers | Export-Csv "User Cleanup Results $CurrentDate.csv" -notypeinformation

Write-Output ($InactiveUsers | Format-Table)

$DeleteInput = Read-Host "Continue with disabling accounts?"

if ($DeleteInput -eq "Y" -OR $DeleteInput -eq "y"){
    Write-output "Disabling accounts."
    $InactiveUsers | Disable-ADAccount
} else {
    Write-output "Not disabling accounts."
}

<#
$aduser = Get-ADUser -Filter * -properties "LastLogonDate" 
#Where-Object ($_.LastLogonDate -gt $MaxLogonDate) |
sort-object -property lastlogondate -Descending |
Format-Table -property name,lastlogondate -AutoSize
#>