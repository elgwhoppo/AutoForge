# Update the package list
sudo apt update

# Install OpenJDK (Java Development Kit)
sudo apt install openjdk-19-jre-headless -y

# Create a directory for Minecraft
sudo mkdir ~/minecraft
sudo chown -R azureuser:azureuser ~/minecraft

# Navigate to the Minecraft directory
cd ~/minecraft

# Download the Minecraft server JAR file
sudo wget -O minecraft_server.jar https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar
sudo wget -O server-icon.png https://forgegaming.us/wp-content/uploads/2023/08/64x64_Site_Forge_Gaming_Hammer_Black_Color_RGB.png
# Replace "<version>" with the actual version you want to download. You can find the actual URL here https://www.minecraft.net/en-us/download/server

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


# Agree to the Minecraft EULA (Edit eula.txt)
echo "Creating config files"
sudo chown -R azureuser:azureuser ~/minecraft
sudo sh -c 'sudo echo "eula=true" > /home/azureuser/minecraft/eula.txt'
sudo sh -c 'echo "server-name=Forge LAN Minecraft" > /home/azureuser/minecraft/server.properties'
sudo sh -c 'echo "motd=Forge LAN Minecraft...for a limited time only!!" >> /home/azureuser/minecraft/server.properties'
sudo sh -c 'echo "gamemode=survival" >> /home/azureuser/minecraft/server.properties'
sudo sh -c 'echo "hardcore=false" >> /home/azureuser/minecraft/server.properties'
sudo sh -c 'echo "pvp=true" >> /home/azureuser/minecraft/server.properties'
sudo sh -c 'echo "difficulty=hard" >> /home/azureuser/minecraft/server.properties' # Allowed values: "peaceful", "easy", "normal", or "hard"
sudo sh -c 'echo "enable-lan-visibility=true" >> /home/azureuser/minecraft/server.properties'
#sudo sh -c 'echo "" >> ~/minecraft/server.properties'

# Start the Minecraft server (adjust the memory settings as needed)
echo "Creating screen launch"
screen -dm -S Minecraft bash -c "java -Xmx2G -Xms2G -jar /home/azureuser/minecraft/minecraft_server.jar nogui"
#sudo java -Xmx10G -Xms10G -jar minecraft_server.jar nogui
# This command starts the server with a maximum heap size of 10GB and an initial heap size of 1GB. You can adjust these values based on your server's available resources.

# Once the server has started successfully, you can stop it by typing "stop" in the server console.
# To run the server in the background, you can use a tool like GNU Screen or tmux.
# Don't forget to open the necessary port (default is 25565) in your server's firewall to allow incoming Minecraft connections.