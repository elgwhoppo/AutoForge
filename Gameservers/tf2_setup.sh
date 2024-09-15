#!/bin/bash

# Set the path to your script
SCRIPT_PATH="/home/azureuser/AutoForge/Gameservers/tf2_update_and_run.sh"

# Set the username
USERNAME="azureuser"

# Create a new crontab file with the reboot entry
echo "@reboot /bin/bash $SCRIPT_PATH" | crontab -u $USERNAME -

# Reboot the machine and kick the script to start the install
#sudo reboot

# Delay the reboot by 10 seconds to allow Terraform to exit cleanly
(sleep 10 && sudo reboot) &