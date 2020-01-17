<#
 Script Name: Cleanup_AD_Users
 Created by Cameron McLean for personal use

 Script to delete user objects unused for 6 months from AD

 Pseudocode if necessary:
-Determine what an unused computer looks like
    -Lastlogontimestamp?
    -Add logic to fix never logged in users
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

$InactiveDaysInput = Read-Host "Enter maximum inactivity period of accounts, or Y to continue with default of $MaxInactiveDays"
if ($InactiveDaysInput -ne "Y" -and $InactiveDaysInput -ne "y"){
    Write-output "Setting maximum inactivity period to $InactiveDaysInput"
    $MaxInactiveDays = $InactiveDaysInput
} else {
    Write-output "Continuing with default 180 days"
}

$MaxLogonDate = (Get-Date).AddDays(-$MaxInactiveDays) # oldest date, everything before this will be cancelled


$aduser = Get-ADUser -Filter * -properties "LastLogonDate" 
#Where-Object ($_.LastLogonDate -gt $MaxLogonDate) |
sort-object -property lastlogondate -Descending |
Format-Table -property name,lastlogondate -AutoSize
