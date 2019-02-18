<#
 Script Name: Delete_ESXi_VM
 Created by Cameron McLean for personal use

 Script to delete ESXi VMs using provided values & PowerCLI

 To-Do:  
 -Rework stop-vm bit to use shutdown-guest and wait for VM to stop, then kill after 30s or so
 -
#>

#Declare variables

$VMName = "null vmname"
$VMHost = "192.168.1.15"
$ConfirmDefaults = $false
$VMList = "null vmlist"
$DeletePermanently = $false

#Get ESXi server info from user
$VMHost = Read-host "What server should this command run on?"
Write-Host "VM removal will run on $VMhost."

#Connect to ESXI server
Write-Host "Connecting to VM Host $VMHost..."
Connect-VIServer -Server $VMHost

#List VMs on server
Write-Host "Listing VMs on server..."
$VMList = Get-VM | Format-Table name,PowerState

#Prompt user for data
while ($ConfirmDefaults) {
	switch (Read-Host "
		Current values, enter number to change:
		1) VMHost = $VMHost
        2) VMName = $VMName
        3) DeletePermanently = $DeletePermanently
		11) Confirm & exit
		"
	)
	{
		"1" {$VMHost = Read-Host "Enter new VMHost"}
        "2" {$VMName = Read-Host "Enter new VMName"}
        "3" {$DeletePermanently = Read-Host "Enter $true or $false to keep or remove storage"}
		"11" {Write-Host "Continuing with current values."
			    $ConfirmDefaults = $false
			}
	}

}

#Validate $VMName exists
if ($VMList -contains "*$VMname"){
    Write-Host "VMList contains VMName, continuing..."
} else{
    Write-host "VMList does not contain VMname, printing..."
    $VMList
    Write-host "VMName is $VMName."
    Write-Host "Exiting..."
    Exit-PSSession
}

#Shut down VM if on, rework later to use shutdown-vmguest
if (VMname on){
    Write-Host "$VMName is powered on, shutting down..."
    Stop-VM $VMName #-Confirm $true #Uncomment to confirm

} else {
    Write-Host "$VMName is powered off, continuing..."
}

#Deletes VM with variables
Write-host "Removing $VMName."
Remove-VM -Name $VMName -VMHost $VMHost 

#Check if $VMname still exists
if (vmname exists){
    get-vm $VMName
    Write-Host "$VMname still exists, check manually."
}else {
    Write-Host "Script completed, $VMName removed."
}