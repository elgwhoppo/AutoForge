# Update the package list
sudo apt update

# Install OpenJDK (Java Development Kit) and JQ (a command-line JSON processor)
sudo apt install openjdk-21-jre-headless jq -y

# Create a directory for Minecraft
sudo mkdir /home/azureuser/minecraft
sudo chown -R azureuser:azureuser /home/azureuser/minecraft

# Navigate to the Minecraft directory
cd /home/azureuser/minecraft

#Kill Minecraft if it's running
# Define the name of the Minecraft Java server process
MINECRAFT_PROCESS_NAME="minecraft_server.jar"

# Find the process IDs (PIDs) of Minecraft server processes
minecraft_pids=$(pgrep -f "$MINECRAFT_PROCESS_NAME")

if [ -z "$minecraft_pids" ]; then
    echo "No Minecraft server processes found."
else
    echo "Found Minecraft server processes with PIDs: $minecraft_pids"
    
    # Loop through the PIDs and kill the processes
    for pid in $minecraft_pids; do
        echo "Killing process with PID $pid"
        kill "$pid"
    done
    
    echo "Killed Minecraft server processes."
fi

# Get the latest version of Minecraft server
latest_version=$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | jq -r '.latest.release')

# Construct the URL for the latest server JAR
server_jar_url=$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | jq -r --arg version "$latest_version" '.versions[] | select(.id == $version) | .url' | xargs -I {} curl -s {} | jq -r '.downloads.server.url')

echo "Latest version: $latest_version"
echo "Server JAR URL: $server_jar_url"

# Download the latest server JAR file
sudo wget -O minecraft_server.jar "$server_jar_url"

# Download the server icon
#sudo wget -O server-icon.png https://forgegaming.us/wp-content/uploads/2023/08/64x64_Site_Forge_Gaming_Hammer_Black_Color_RGB.png
sudo wget -O server-icon.png https://forgegaming.us/wp-content/uploads/2024/09/64x64_october.png

# Download FG uploaded Map Files
sudo wget -O Huge_Minas_Tirith_Divici.zip https://forgegaming.us/wp-content/uploads/2024/09/Huge_Minas_Tirith_Divici.zip
sudo unzip Huge_Minas_Tirith_Divici
sudo wget -O Midtown_Manhattan.zip https://forgegaming.us/wp-content/uploads/2024/09/Midtown_Manhattan.zip
sudo unzip Midtown_Manhattan
sudo wget -O Minecraft_Star_Wars_Space_World.zip https://forgegaming.us/wp-content/uploads/2024/09/Minecraft_Star_Wars_Space_World.zip
sudo unzip Minecraft_Star_Wars_Space_World
sudo wget -O Hogwarts_Castle_v.1.1_by_Gabbel.zip https://forgegaming.us/wp-content/uploads/2024/09/Hogwarts_Castle_v.1.1_by_Gabbel.zip
sudo unzip /home/azureuser/minecraft/Hogwarts_Castle_v.1.1_by_Gabbel.zip -d /home/azureuser/minecraft/Hogwarts_Castle_Unzip
sudo wget -O minecraftmaps.com-CreepyBlackstoneCastle_by_NevasBuildings.zip https://forgegaming.us/wp-content/uploads/2024/09/minecraftmaps.com-CreepyBlackstoneCastle_by_NevasBuildings.zip
sudo unzip minecraftmaps.com-CreepyBlackstoneCastle_by_NevasBuildings -d /home/azureuser/minecraft/CreepyUnzip

# Rename folders to remove spaces
sudo mv "/home/azureuser/minecraft/Hogwarts_Castle_Unzip/Hogwarts Castle - v.1.1.0 - by Gabbel/" /home/azureuser/minecraft/Hogwarts_Castle_by_Gabbel_Map
sudo rm /home/azureuser/minecraft/Hogwarts_Castle_by_Gabbel_Map/session.lock
sudo mv '/home/azureuser/minecraft/New York - Midtown Manhattan by BasVerhagen 2.9 - 1.19.4' /home/azureuser/minecraft/Midtown_Manhattan_by_BasVerhagen
sudo mv '/home/azureuser/minecraft/Star Wars Space World' /home/azureuser/minecraft/Star_Wars_Space_World
sudo rm /home/azureuser/minecraft/CreepyUnzip/CreepyBlackstoneCastle_By_NevasBuildings/session.lock

# Not sure why I need this, but OK
sudo chown -R azureuser:azureuser /home/azureuser/minecraft
sudo chmod -R 755 /home/azureuser/minecraft

# Agree to the Minecraft EULA (Edit eula.txt)
echo "Creating config files"
sudo sh -c 'sudo echo "eula=true" > /home/azureuser/minecraft/eula.txt'
sudo sh -c 'echo "server-name=Forge LAN 21 Minecraft Server" > /home/azureuser/minecraft/server.properties'
sudo sh -c 'echo "motd=The Hunt...for Red October!!" >> /home/azureuser/minecraft/server.properties'
sudo sh -c 'echo "gamemode=creative" >> /home/azureuser/minecraft/server.properties'
sudo sh -c 'echo "hardcore=false" >> /home/azureuser/minecraft/server.properties'
sudo sh -c 'echo "pvp=false" >> /home/azureuser/minecraft/server.properties'
sudo sh -c 'echo "difficulty=hard" >> /home/azureuser/minecraft/server.properties' # Allowed values: "peaceful", "easy", "normal", or "hard"
sudo sh -c 'echo "max-players=100" >> /home/azureuser/minecraft/server.properties'
sudo sh -c 'echo "enable-command-block=true" >> /home/azureuser/minecraft/server.properties'
sudo sh -c 'echo "spawn-animals=false" >> /home/azureuser/minecraft/server.properties'
sudo sh -c 'echo "spawn-monsters=false" >> /home/azureuser/minecraft/server.properties'
#sudo sh -c 'echo "" >> ~/minecraft/server.properties'

# Create other scripts to start other maps in the home directory
sudo sh -c 'echo "screen -dm -S MinecraftWorld bash -c \"java -Xmx7G -Xms5G -jar /home/azureuser/minecraft/minecraft_server.jar nogui\"" > /home/azureuser/minecraft/start_world.sh'
sudo chmod +x start_world.sh

sudo sh -c 'echo "screen -dm -S MinecraftCreepyCastle bash -c \"java -Xmx7G -Xms5G -jar /home/azureuser/minecraft/minecraft_server.jar nogui --world /home/azureuser/minecraft/CreepyUnzip/CreepyBlackstoneCastle_By_NevasBuildings\"" > /home/azureuser/minecraft/start1_castle.sh'
sudo chmod +x start1_castle.sh

sudo sh -c 'echo "screen -dm -S MinecraftStarWar bash -c \"java -Xmx7G -Xms5G -jar /home/azureuser/minecraft/minecraft_server.jar nogui --world Star_Wars_Space_World\"" > /home/azureuser/minecraft/start2_starwar.sh'
sudo chmod +x start2_starwar.sh

sudo sh -c 'echo "screen -dm -S MinecraftHogwarts bash -c \"java -Xmx7G -Xms5G -jar /home/azureuser/minecraft/minecraft_server.jar nogui --world /home/azureuser/minecraft/Hogwarts_Castle_by_Gabbel_Map\"" > /home/azureuser/minecraft/start3_hogwarts.sh'
sudo chmod +x start3_hogwarts.sh

sudo sh -c 'echo "screen -dm -S MinecraftMinas bash -c \"java -Xmx7G -Xms5G -jar /home/azureuser/minecraft/minecraft_server.jar nogui --world Huge_Minas_Tirith_Divici\"" > /home/azureuser/minecraft/start4_minas.sh'
sudo chmod +x start4_minas.sh

sudo sh -c 'echo "screen -dm -S MinecraftManhattan bash -c \"java -Xmx7G -Xms5G -jar /home/azureuser/minecraft/minecraft_server.jar nogui --world Midtown_Manhattan_by_BasVerhagen\"" > /home/azureuser/minecraft/start5_manhattan.sh'
sudo chmod +x start5_manhattan.sh

# Start the Minecraft server (adjust the memory settings as needed)
echo "Creating screen launch"
screen -dm -S Minecraft bash -c "java -Xmx7G -Xms5G -jar /home/azureuser/minecraft/minecraft_server.jar nogui"

#sudo java -Xmx10G -Xms10G -jar minecraft_server.jar nogui
# This command starts the server with a maximum heap size of 10GB and an initial heap size of 1GB. You can adjust these values based on your server's available resources.

# Once the server has started successfully, you can stop it by typing "stop" in the server console.
# To run the server in the background, you can use a tool like GNU Screen or tmux.
# Don't forget to open the necessary port (default is 25565) in your server's firewall to allow incoming Minecraft connections.