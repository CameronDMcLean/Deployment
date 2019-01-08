### Telegraf_Deploy.ps1 ###
### Script to deploy Telegraf and register as service ###
### Made by Cameron McLean for personal use ###

# Copy Telegraf files to install directory
Write-Host "Copying Telegraf Files"
Copy-Item "\\labsrvnas01\startup_scripts\Telegraf" -Destination "C:\Program Files\Telegraf" -Recurse

# Installs Telegraf Service
Write-Host "Installing Telegraf Service"
C:\"Program Files"\Telegraf\telegraf.exe --service install

# Set service recovery actions to restart
# Restart time is in milliseconds (180000 = 3 mins), reset is in seconds (86400 = 1 day)
# After running 1st & 2nd failure will restart, 3rd will take no action
Write-Host "Setting Telegraf service recovery options"
sc failure "telegraf"  actions= restart/180000/restart/180000/""/180000 reset= 86400

# Start service
Write-Host "Starting Telegraf Service"
Net start telegraf

# Runs test telegraf, prints results to stdout then pauses
Write-Host "Running test telegraf"
Start-Process "C:\Program Files\telegraf\telegraf.exe\" --test
pause