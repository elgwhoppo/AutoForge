#!/bin/bash

#Install TF2
sudo mkdir ~/steam && cd ~/steam
steamcmd +force_install_dir ./tf2 +login anonymous +app_update 232250 +quit

#Install Metamod and Sourcemod into TF2 Server
cd ~/steam
sudo wget https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1148-linux.tar.gz
sudo wget https://sm.alliedmods.net/smdrop/1.11/sourcemod-1.11.0-git6936-linux.tar.gz
sudo tar -zxvf mmsource-1.11.0-git1148-linux.tar.gz -C ~/.local/share/Steam/steamcmd/tf2/tf
sudo tar -zxvf sourcemod-1.11.0-git6936-linux.tar.gz -C ~/.local/share/Steam/steamcmd/tf2/tf

#Configure the server parameters and make JOOOOOOOOOO_ an admin. 
sudo echo ""STEAM_0:0:16152087" "99:z"" > ~/.local/share/Steam/steamcmd/tf2/tf/addons/sourcemod/configs/admins_simple.ini
sudo cat << EOF > ~/.local/share/Steam/steamcmd/tf2/tf/cfg/motd.txt
Welcome to Forge Gaming's TF2 Server!

Be nice and cool and all that fun stuff. Right now JOOOOOOOOOO is the only admin. 

: )
EOF
sudo cat << EOF > ~/.local/share/Steam/steamcmd/tf2/tf/cfg/server.cfg
// Hostname for server.
hostname "Forge Gaming TF2"

// Overrides the max players reported to prospective clients
sv_visiblemaxplayers 32

// Maximum number of rounds to play before server changes maps
mp_maxrounds 3

// Control where the client gets content from 
// 0 = anywhere, 1 = anywhere listed in white list, 2 = steam official content only
sv_pure 0

// Is the server pausable
sv_pausable 0

// Type of server 0=internet 1=lan
sv_lan 0

// Collect CPU usage stats
sv_stats 1

// Team Balancing //

// Enable team balancing
mp_autoteambalance 0

// Time after the teams become unbalanced to attempt to switch players.
mp_autoteambalance_delay 60

// Time after the teams become unbalanced to print a balance warning
mp_autoteambalance_warning_delay 30

// Teams are unbalanced when one team has this many more players than the other team. (0 disables check)
mp_teams_unbalance_limit 1

// Communications //

// enable voice communications
sv_voiceenable 1

// Players can hear all other players, no team restrictions 0=off 1=on
sv_alltalk 0
EOF

#Start TF2 Server
screen -dm -S TF2Server bash -c "~/.local/share/Steam/steamcmd/tf2/srcds_run -port 27015 -console -game tf +randommap +maxplayers 32"