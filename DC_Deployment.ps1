#
# Script Name: DC_Deployment.ps1
# Created by Cameron McLean for personal use
#
# Script to deploy domain controllers
#
# To-Do: 
# -Set NTP server / timezone? 
# -

$NewHostname #Naming convention LabSrvxxx0y
$Credential Get-Credential
$NewIP
$NewDNSServers #Default 127.0.0.1
$InterfaceAlias #Default Ethernet
$Prefix #Default 24
$DefaultGateway #Default "192.168.100.1, 192.168.1.1"

#Renames local host to $NewHostname using $credential, then restarts
Rename-computer   –newname $NewHostName –domaincredential $credential –force –restart

#Set IP address & DNS using variables above
#Get-NetIPAddress shows interface aliases, default Hyper-V VM is "Ethernet"
New-NetIPAddress –InterfaceAlias $InterfaceAlias –IPAddress $NewIP –PrefixLength $Prefix -DefaultGateway $DefaultGateway
Set-dnsclientserveraddress -interfacealias $InterfaceAlias -serveraddress $NewDNSServers

Add-WindowsFeature AD-Domain-Services

<# 
# Join camlab & sync with camlab.local
	Import-Module ADDSDeployment
	Install-ADDSDomainController `
	-NoGlobalCatalog:$false `
	-CreateDnsDelegation:$false `
	-Credential (Get-Credential) `
	-CriticalReplicationOnly:$false `
	-DatabasePath "C:\Windows\NTDS" `
	-DomainName "CAMLAB.local" `
	-InstallDns:$true `
	-LogPath "C:\Windows\NTDS" `
	-NoRebootOnCompletion:$false `
	-ReplicationSourceDC "Camlab-DC01.camlab.local" `
	-SiteName "Default-First-Site-Name" `
	-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true
#>

<#
# create labds.cammclean.me
Import-Module ADDSDeployment
	Install-ADDSForest 
	-CreateDnsDelegation:$false
	-DatabasePath “C:\Windows\NTDS”
	-DomainMode “Win2012R2”
	-DomainName “LabDS.cammclean.me”
	-DomainNetbiosName “LabDS”
	-ForestMode “Win2012R2”
	-InstallDns:$true
	-LogPath “C:\Windows\NTDS”
	-NoRebootOnCompletion:$false
	-SysvolPath “C:\Windows\SYSVOL”
	-Force:$true

#>

#Configure DHCP
<#Install-WindowsFeature -Name 'DHCP'
Add-DhcpServerV4Scope -Name "LabDS Scope" -StartRange 192.168.1.100 -EndRange 192.168.1.250 -SubnetMask 255.255.255.0
Set-DhcpServerV4OptionValue -DnsServer 192.168.1.35 -Router 192.168.1.1
Set-DhcpServerv4Scope -ScopeId 192.168.1.1 -LeaseDuration 1.00:00:00
Add-DhcpServerInDC
Restart-service dhcpserver
#>

<#
Script from DC02 setup:
#
# Windows PowerShell script for AD DS Deployment
#

Import-Module ADDSDeployment
Install-ADDSDomainController `
-NoGlobalCatalog:$false `
-CreateDnsDelegation:$false `
-Credential (Get-Credential) `
-CriticalReplicationOnly:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainName "LabDS.cammclean.me" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SiteName "Default-First-Site-Name" `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true

#>