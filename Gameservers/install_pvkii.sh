#!/bin/bash

#Install PVKII
sudo mkdir ~/steam && cd ~/steam
steamcmd +force_install_dir ./pvkii +login anonymous +app_update 17575 +quit

#Configure the server parameters and make JOOOOOOOOOO_ an admin. 
sudo cat << EOF > ~/.local/share/Steam/steamcmd/pvkii/pvkii/cfg/motd.txt
Welcome to Forge Gaming's PVKII Server!

Be nice and cool and all that fun stuff. Right now JOOOOOOOOOO is the only admin. 

: )
EOF

#Configure the server parameters 
sudo cat << EOF > ~/.local/share/Steam/steamcmd/pvkii/pvkii/cfg/server.cfg
hostname "Forge Gaming PVKII server"

mp_timelimit 7
mp_timelimit_waitroundend 1

mp_roundtime 2
mp_roundlimit 0
mp_winlimit 0
rcon_password "chungus"

// sv_region tells the Steam servers where your server is located, possible values are:
// 0 - US East coast
// 1 - US West coast
// 2 - South America
// 3 - Europe
// 4 - Asia
// 5 - Australia
// 6 - Middle East
// 7 - Africa

sv_region 0

// Minimum values for rates should not be changed.
sv_minupdaterate 20
sv_maxupdaterate 60
sv_mincmdrate 30
sv_maxcmdrate 60
sv_minrate 10000
sv_maxrate 30000


sv_master_legacy_mode 0
EOF

#Start PVKII Server
screen -dm -S PVKIIServer bash -c "~/.local/share/Steam/steamcmd/pvkii/srcds_run -console -game pvkii -maxplayers 32 +map bt_island"

#Admin Tips: 
#Once at the console use rcon_password commmand to set it. Then use it in-game. 
#
#example: rcon_password chungus
#example: rcon moveplayer JOOOOOOOOOO pirates  