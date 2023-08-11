#!/bin/bash

#Install PVKII
sudo mkdir ~/steam && cd ~/steam
#steamcmd +force_install_dir ./pvkii +login anonymous +app_update 17575 +quit

#Install Metamod and Sourcemod into TF2 Server
# this mod doesn't work??? to fix?
cd ~/steam
sudo wget https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1148-linux.tar.gz
sudo wget https://sm.alliedmods.net/smdrop/1.11/sourcemod-1.11.0-git6936-linux.tar.gz
sudo tar -zxvf mmsource-1.11.0-git1148-linux.tar.gz -C ~/.local/share/Steam/steamcmd/pvkii/pvkii
sudo tar -zxvf sourcemod-1.11.0-git6936-linux.tar.gz -C ~/.local/share/Steam/steamcmd/pvkii/pvkii

#Configure the server parameters and make JOOOOOOOOOO_ an admin. 
sudo echo ""STEAM_0:0:16152087" "99:z"" > ~/.local/share/Steam/steamcmd/pvkii/pvkii/addons/sourcemod/configs/admins_simple.ini
sudo cat << EOF > ~/.local/share/Steam/steamcmd/pvkii/pvkii/cfg/motd.txt
Welcome to Forge Gaming's PVKII Server!

Be nice and cool and all that fun stuff. Right now JOOOOOOOOOO is the only admin. 

: )
EOF

#Start PVKII Server
screen -dm -S TF2Server bash -c "~/.local/share/Steam/steamcmd/pvkii/srcds_run -console -game pvkii -maxplayers 32 +map bt_island"
