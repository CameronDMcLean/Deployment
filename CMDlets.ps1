<#
 Script Name: CMDlets.ps1
 Created by Cameron McLean for personal use

 Script to store useful one-liners

 To-Do:  
 -
 -
#>

#Starts *vscode* with install arguments, meant for use in mdt
Start-Process *VSCode* -ArgumentList "/verysilent /mergetasks='!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath'" -wait