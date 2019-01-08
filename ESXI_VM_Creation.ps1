<#
 Script Name: ESXI_VM_Creation.ps1
 Created by Cameron McLean for personal use

 Script to set configure ESXI vms via powercli
 Shortcut - ref https://thesolving.com/virtualization/how-to-install-and-configure-vmware-powercli-version-10/

 To-Do: 
 -Sample VM creation cmdlets
 -Make function? to pass variables through
#>

#Install the PS function
Install-Module -Name Vmware.PowerCLI -AllowClobber

#Connect to server
$PSCredential = Get-Credential
connect-viserver –server “ServerNameOrIP” –credential $PSCredential

#Fix untrusted cert until I get a CA set up
Set-PowerCLIConfiguration -InvalidCertificateAction ignore #-confirm:$false #Confirm stops confirm message from showing

<# Random notes
#List VMs, supports PS like syntax. | FL lists full info
Get-VM | fl

#Create VM
New-VM	-vmhost 192.168.1.15 -datastore "4TB" -name LabSrvPowerCLI #Creates VM
New-HardDisk -VM LabSrvPowerCLI -CapacityKB 40960
New-NetworkAdapter -VM "LabSrvPowerCLI" -NetworkName "VM Network"

#Stop VM
Stop-VMGuest #-confirm:false #Stops VM, confirm false turns off user prompting

#Get list of VMs with certain attribute
Get-vm | where-object {$_.MemoryGB –eq 4 } 

#Gets VM host attributes
Get-VMhost | select name,state,model,version,build
#>

#Create VM, HDD & NIC
New-VM	-vmhost 192.168.1.15 -datastore "4TB" -name LabSrvPowerCLI #Creates VM
New-HardDisk -VM LabSrvPowerCLI -CapacityKB 40960
New-NetworkAdapter -VM "LabSrvPowerCLI" -NetworkName "VM Network"