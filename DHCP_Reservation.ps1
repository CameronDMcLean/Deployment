#
# Script Name: DHCP_Reservation.ps1
# Created by Cameron McLean for personal use
#
# Script to set DHCP reservations
#
# To-Do: 
# -Detect MAC address / prompt for interface to use
# -Remote powershell into dc03 (?) & add reservation

#Getting information from user
$DHCPServer = Read-Host "Enter DHCP server - default LabSrvDC03"
$IPAddress =  Read-Host "Enter desired IP address"
$ComputerName = $env:COMPUTERNAME

#Prompt user for DHCP scope or set to default (192.138.1.0)
$ScopeID = if(($DefaultScope = Read-Host "Enter DHCP Scope ID or press enter to accept default value [192.168.1.0]") -eq ''){"192.168.1.0"}else{$DefaultScope}
$ScopeID = if(($DefaultScope = Read-Host "Enter DHCP Scope ID or press enter to accept default value [192.168.1.0]") -eq ''){"192.168.1.0"}else{$DefaultScope}
$Computername


#Write variables to stdout for debugging
Write-Host $IPaddress, $ComputerName, $Description, $ScopeID


#PS C:\> Add-DhcpServerv4Reservation -ScopeId 10.10.10.0 -IPAddress 10.10.10.8 -ClientId "F0-DE-F1-7A-00-5E" -Description "Reservation for Printer"



<#

 
$DHCPServer = "DHCPSRV01" # Please change it with your server name. 
$ScopeID = "192.168.1.0" # Please check it with your scope Id. 
$CSVlocation = "C:\temp\ipaddresses.csv" # Please change the path as per your requirements. 
$ShouldBeReserved = Import-Csv -Path $CSVlocation 
$CurrentReserved = Get-DhcpServerv4Reservation -ComputerName $DHCPServer -ScopeId $ScopeID 
 
Foreach ($IP in $ShouldBeReserved){
    if ($CurrentReserved.IPAddress.IPAddressToString -contains $IP.IP){
    Write-Host "DHCP Reservation Exist for"$IP.IP"under ScopeID"$ScopeID -ForegroundColor Cyan
    }
    else
    {
    $ReserveIP = Add-DhcpServerv4Reservation -ComputerName $DHCPServer -ScopeId $ScopeID -IPAddress $IP.IP -ClientId $IP.Mac -Name $IP.Hostname -Type Both
        if($ReserveIP -eq $null){
        Write-Host "Reservation has been created for"$IP.IP"for Host"$IP.Hostname"under ScopeID"$ScopeID -ForegroundColor Cyan
        }
        else {
        Write-Host "Please check the details of"$IP.IP ", something is wrong. So reservation is not created." -ForegroundColor Cyan
        }
    }
}

#>

<#

#IP to Change
$ipaddress = '192.168.3.90’

#New IP
$newip = '192.168.3.100’

#DHCP Server
$dhcpserver = 'dc1'

#Current Reservation Description
$description = Get-DhcpServerv4Scope -ComputerName $dhcpserver | Get-DhcpServerv4Reservation -ComputerName $dhcpserver | where {$_.ipaddress -eq $ipaddress} | select -expandproperty description 

#Current Reservation Scope ID
$scopeid = Get-DhcpServerv4Scope -ComputerName $dhcpserver | Get-DhcpServerv4Reservation -ComputerName $dhcpserver | where {$_.ipaddress -eq $ipaddress} | foreach {$_.scopeid.ipaddresstostring}

#Current Reservation MAC
$mac = Get-DhcpServerv4Scope -ComputerName $dhcpserver|  Get-DhcpServerv4Reservation -ComputerName $dhcpserver | where {$_.ipaddress -eq $ipaddress} | select -expandproperty clientid

#Current Reservation Name
$name = Get-DhcpServerv4Scope -ComputerName $dhcpserver|  Get-DhcpServerv4Reservation -ComputerName $dhcpserver | where {$_.ipaddress -eq $ipaddress} | select -expandproperty name

#Delete Current Reservation
Remove-DhcpServerv4Reservation -ComputerName $dhcpserver -IP $ipaddress

#Recreate Reservation With New IP
Add-DhcpServerv4Reservation -ComputerName $dhcpserver -Name $name -ScopeId $scopeid -IPAddress $newip -ClientId $mac -Description $description

#>