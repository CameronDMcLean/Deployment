<#
 Script Name: Create_ESXi_VM
 Created by Cameron McLean for personal use

 Script to create ESXi VMs using provided values & PowerCLI

 To-Do:  
 -Add tostring decimal lengths to vnmaneincrement such that the final output fits the two-digit naming convention
 -Test the whole thing & make sure it works
 -Check if VM exists at the same time VMName is filled by the user - add to switch statement?
 -Explore invoke-VM per Dan W
#>

#Declare variables
$VMName = "TestVM Default"
$VMHost = "192.168.1.15"
$VMDatastore = "8TB" #List with get-datastore   
$VMDiskGB = "40"
$VMMemoryGB = "2"
$VMNumCPU = "1"
$VMNetworkName = "VM Network"
$VMAutostart = $false
$VMTurnOn = $true
$VMGuestID = "windows9Server64Guest" #Sets NIC and SCSI adapter type, ref https://www.vmware.com/support/developer/windowstoolkit/wintk40u1/html/New-VM.html
$ConfirmDefaults = $true
$VMNameExists = $true
$VMNameIncrement = 1

#Test code for selecting values

while ($ConfirmDefaults) {
	switch (Read-Host "
		Current values, enter number to change:
		1) VMHost = $VMHost
		2) VMName = $VMName
		3) VMDatastore = $VMDatastore
		4) VMDiskGB = $VMDiskGB
		5) VMMemoryGB = $VMMemoryGB
		6) VMNumCPU = $VMNumCPU
		7) VMNetworkName = $VMNetworkName
		8) VMAutostart = $VMAutostart
		9) VMTurnOn = $VMTurnOn
		10) VMGuestID = $VMGuestID
		11) Confirm & exit
		12) Cancel script
		"
	)
	{
		"1" {$VMHost = Read-Host "Enter new VMHost"}
		"2" {$VMName = Read-Host "Enter new VMName"}
		"3" {$VMDatastore = Read-Host "Enter new VMDatastore"}
		"4" {$VMDiskGB = Read-Host "Enter new VMDiskGB"}
		"5" {$VMMemoryGB = Read-Host "Enter new VMMemoryGB"}
		"6" {$VMNumCPU = Read-Host "Enter new VMNumCPU"}
		"7" {$VMNetworkName = Read-Host "Enter new VMNetworkName"}
		"8" {$VMAutostart = Read-Host "Enter new VMAutostart"}
		"9" {$VMTurnOn = Read-Host "Enter new VMTurnOn"}
		"10" {$VMGuestID = Read-Host "Enter new VMGuestID"}
		"11" {Write-Host "Continuing with current values."
			$ConfirmDefaults = $false
			}
		"12" {Write-host "Cancelling VM config script" return}	
		
	}

}

#Connect to ESXI server
Write-Host "Connecting to VM Host" $VMHost
Connect-VIServer -Server $VMHost

# Code to auto generate $VMName
#While $VMNameExists loop
#Check if VMName + VMNameIncrement exists, if it does then add 1 to vmnameincrement
#If it doesn't exist, continue
<#
while ($VMNameExists){

	#Tests for existing VM using both variables, returns true if exists or null if not
	$VMNameExists = Get-VM -name ($VMName + $VMNameIncrement) -erroraction silentlycontinue

	if (!$VMNameExists){
		Write-Host "Using"($VMName + $VMNameIncrement)
		$VMName = ($VMName + $VMNameIncrement.ToString)
		$VMNameExists = $false
		
	} else {
		Write-host "$VMName already exists, adding 1"
		$VMnameIncrement +=1
		
	}
}
#>

#Creates VM with variables
Write-host "Creating VM" $VMName
New-VM -Name $VMName -VMHost $VMHost -Datastore $VMDatastore -DiskGB $VMDiskGB -MemoryGB $VMMemoryGB -NumCpu $VMNumCPU -NetworkName $VMNetworkName -GuestId $VMGuestID

#Sets VM to power on automatically
if ($VMAutostart){
    Write-host "Enabling Autostart on VM"
    Set-VMStartPolicy -StartPolicy (Get-VMStartPolicy -VM $VMName) -StartAction PowerOn
} Else {write-host "Not configuring autostart on VM"} 


if ($VMTurnOn){
    Write-host "Turning VM on"
    Start-VM -VM $VMName 
} Else {write-host "Leaving VM off"}

Write-Host "Script completed, $VMName created."

<#
cmdlets for testing
#Powers off VM without waiting for guest OS
stop-vm $vmName -confirm:$false
#Permanently removes VM & VM files
remove-vm $VMName -deletepermanently # Fully deletes $VMName
#>