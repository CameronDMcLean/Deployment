<#
 Script Name: Jumpbox_Deployment.ps1
 Created by Cameron McLean for personal use

 Script to gather config info for all jumpbox tools to import to MDT programs. 
 Original from 

 To-Do:      
Microsoft Deployment Toolkit (6.3.8450.1000)                    6.3.8450.1000   
Windows System Image Manager on amd64                           10.1.17763.1    
Windows Deployment Tools                                        10.1.17763.1    
WPTx64                                                          10.1.17763.1          
Toolkit Documentation                                           10.1.17763.1    
Kits Configuration Installer                                    10.1.17763.1    
Systems Management Software (64-Bit)                            8.5.0                
Windows Deployment Customizations                               10.1.17763.1    
Imaging And Configuration Designer                              10.1.17763.1     
tera term / putty?
#>

#installs PuTTY, alternatively copy putty.exe to some directory and launch from there. 
msiexec /i .\putty-64bit-0.70-installer.msi /q #Should work but generates an "installer is not valid MSI package" error when run from PS


#Installs 7zip in silent mode https://www.7-zip.org/faq.html
start .\7z1805-x64.exe /S

#Installs VMware remote console, update program version when adding to MDT 
VMware-VMRC-10.0.2-7096020.exe /V /Qn EULAS_AGREED=1 AUTOSOFTWAREUPDATE=0 ATACOLLECTION=0

#Installs notepad++ https://www.manageengine.com/products/desktop-central/software-installation/silent_install_Notepad++-6.9.2.html
start npp.7.6.1.Installer.x64.exe /S

#Installs wireshark (no winPcap but it works anyways, need to test from fresh PC) https://www.wireshark.org/docs/wsug_html_chunked/ChBuildInstallWinInstall.html
.\Wireshark-win64-2.6.4.exe /S

#Installs NMAP with default settings https://nmap.org/npcap/guide/npcap-users-guide.html
.\nmap-7.70-setup.exe /S

#Installs RSAT with all features
Install-WindowsFeature -IncludeAllSubFeature RSAT