# Update the package list
sudo apt update

# Install OpenJDK (Java Development Kit)
sudo apt install openjdk-19-jre-headless -y

# Create a directory for Minecraft
sudo mkdir ~/minecraft

# Navigate to the Minecraft directory
cd ~/minecraft

# Download the Minecraft server JAR file
sudo wget -O minecraft_server.jar https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar
sudo wget -O server-icon.png https://forgegaming.us/wp-content/uploads/2023/08/64x64_Site_Forge_Gaming_Hammer_Black_Color_RGB.png
# Replace "<version>" with the actual version you want to download. You can find the actual URL here https://www.minecraft.net/en-us/download/server

# Agree to the Minecraft EULA (Edit eula.txt)
echo "eula=true" > ~/minecraft/eula.txt
echo "server-name=Forge LAN Minecraft" > ~/minecraft/server.properties
echo "motd=Forge LAN Minecraft...for a limited time only!!" >> ~/minecraft/server.properties
echo "gamemode=survival" >> ~/minecraft/server.properties
echo "hardcore=false" >> ~/minecraft/server.properties
echo "pvp=true" >> ~/minecraft/server.properties
echo "difficulty=hard" >> ~/minecraft/server.properties # Allowed values: "peaceful", "easy", "normal", or "hard"
echo "enable-lan-visibility=true" >> ~/minecraft/server.properties
#echo "" >> ~/minecraft/server.properties

# Start the Minecraft server (adjust the memory settings as needed)
sudo java -Xmx10G -Xms10G -jar minecraft_server.jar nogui
# This command starts the server with a maximum heap size of 10GB and an initial heap size of 1GB. You can adjust these values based on your server's available resources.

# Once the server has started successfully, you can stop it by typing "stop" in the server console.
# To run the server in the background, you can use a tool like GNU Screen or tmux.
# Don't forget to open the necessary port (default is 25565) in your server's firewall to allow incoming Minecraft connections.