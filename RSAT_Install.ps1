#
# Script Name: RSAT_Install.ps1
# Created by Cameron McLean for personal use
#
# Script to install all RSAT tools
# Original from https://www.ntweekly.com/2017/07/04/install-all-rsat-tools-in-one-single-cmdlet-on-windows-server-2016/
# To-Do: 
# - Merge into larger "workstation" deployment script
# -

# Run in powershell
Install-WindowsFeature -IncludeAllSubFeature RSAT
