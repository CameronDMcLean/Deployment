#
# Script Name: VM_Creation.ps1
# Created by Cameron McLean for personal use
#
# Script to create Hyper-V VMs. Queries user for multiple variables & then deploys. 
#
# To-Do: 
# -
# -

$VmName # Virtual machine name
$VmMemory # VM Memory in GB, ex. 2GB
$VHDPath # VHD path, eg d:\vhd\base.vhdx

New-VM -Name $VmName -MemoryStartupBytes $VmMemory -NewVHDPath $VHDPath
