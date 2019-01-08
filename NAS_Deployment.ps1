<#
 Script Name: NAS_Deployment.ps1
 Created by Cameron McLean for personal use

 Script to configure NAS shares. To be run after installing server 2016 core & joining to domain. 
 Goal is to be able to attach VMDK to this server & then have it share 

 To-Do:  
 -Will the VMDK always show as the same drive letter?
	-Yes but it's offline by default
   #>

  #Installs file services windows feature
  Write-Output "Installing file services role"
  Install-WindowsFeature file-services
  Write-Output "File services role installed"

  $Shares = @("Backups", "IT", "Startup_Scripts", "VMs", "Media")

  #Creates all shares with default permissions 
  Write-Output "Creating shares"

  foreach ($Share in $Shares){

	  #New-Item "E:\$Share" -type directory #Create folders for testing
	  New-SmbShare -Name "$Share" -Path "E:\$Share"

	  #Grant full SMB access to shares - note SMB vs NTFS, all restrictions are done in NTFS later on
	  Revoke-SmbShareAccess -Name "$Share" -Force -AccountName "Everyone"
	  Grant-SmbShareAccess -Name "$Share" -Force -AccountName "LabDS\Domain Users" -AccessRight Full

	  #Set NTFS ACLs (note access is actually controlled here)
	  $Acl = Get-Acl "E:\$Share"
	  $Ar = New-Object  system.security.accesscontrol.filesystemaccessrule("LabDS\LabNASFull","FullControl","Allow")
      $Acl.AddAccessRule($Ar)
	  Set-Acl -Path "E:\$Share" -AclObject $Acl

  }

  #Lists access for all shares. Maybe clean up for only shares created by this script?
  Get-SmbShare | Get-SmbShareAccess
  
  Write-Output "Shares created"

  <#
  #Removes shares for testing
  remove-smbshare Backups, IT, Startup_Scripts, VMs, Media -force
  get-smbshare
  #>

  #add something for turning disk online in diskpart (need to reboot so this would be a separate script)
  # ref https://social.technet.microsoft.com/Forums/windowsserver/en-US/97e7b613-b422-427a-bb41-6f475f38d2ac/creating-a-diskpart-script-file-using-powershell?forum=winserverpowershell
  #Diskpart online disk 1 
  #Diskpart sel disk 1
  #Diskpart attributes disk clear readonly