#!/bin/bash

# Set the path to your script
SCRIPT_PATH="/home/azureuser/AutoForge/Gameservers/minecraft_update_and_run.sh"

# Set the username
USERNAME="azureuser"

# Create a new crontab file with the reboot entry
echo "@reboot /bin/bash $SCRIPT_PATH" | crontab -u $USERNAME -

# Reboot the machine and kick the script to start the install
sudo reboot