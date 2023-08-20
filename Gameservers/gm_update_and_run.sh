#!/bin/bash

#Install Garry's Mod
sudo mkdir /home/azureuser/steam && cd /home/azureuser/steam
steamcmd +force_install_dir ./gm +login anonymous +app_update 4020 +quit

#Install Metamod and Sourcemod into TF2 Server
cd /home/azureuser/steam

sudo cat << EOF > /home/azureuser/.local/share/Steam/steamcmd/gm/garrysmod/cfg/motd.txt
Welcome to Forge Gaming's Garry's Mod Server!

Be nice and cool and all that fun stuff. Right now JOOOOOOOOOO is the only admin. 

: )
EOF
sudo cat << EOF > /home/azureuser/.local/share/Steam/steamcmd/gm/garrysmod/cfg/server.cfg
// Hostname for server.
hostname "Forge Gaming Garry's Mod"

// Overrides the max players reported to prospective clients
sv_visiblemaxplayers 32

// Maximum number of rounds to play before server changes maps
mp_maxrounds 1

// Control where the client gets content from 
// 0 = anywhere, 1 = anywhere listed in white list, 2 = steam official content only
sv_pure 0

// Is the server pausable
sv_pausable 0

// Type of server 0=internet 1=lan
sv_lan 0

// Collect CPU usage stats
sv_stats 1

// Communications //

// enable voice communications
sv_voiceenable 1

// Players can hear all other players, no team restrictions 0=off 1=on
sv_alltalk 0
EOF

#Start GM Server
screen -dm -S GMServer bash -c "/home/azureuser/.local/share/Steam/steamcmd/gm/srcds_run -port 27015 -console -game garrysmod +maxplayers 32"
