<#
 Script Name: CMDlets.ps1
 Created by Cameron McLean for personal use

 Script to store useful one-liners

 To-Do:  
 -
 -
#>

#Install VS Code from local folder. Starts *vscode* with install arguments, meant for use in mdt. Starts with code open, need to adjust
Start-Process VSCodeSetup-x64-1.31.1.exe /verysilent /mergetasks='!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath' -Wait

#Installs GitHub Desktop - note install runs on every user login
start GitHubDesktopSetup.msi