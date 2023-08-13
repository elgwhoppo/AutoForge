#!/bin/bash

# Define variables
MINECRAFT_JAR="server.jar"
MINECRAFT_JAR_FULL="~/minecraft/server.jar"
JAVA_PATH="/usr/bin/java"  # Path to your Java executable
MEMORY="4G"  # Amount of RAM to allocate to the server

# Function to check for server updates
# Function to check for server updates and download the latest JAR
check_update() {
    echo "Checking for Minecraft server update..."
    cd ~/minecraft
    LATEST_VERSION=$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | grep -oP '(?<="release": ")[^"]*')
    echo "Latest Minecraft version: $LATEST_VERSION"

    if [ -f "$MINECRAFT_DIR/$MINECRAFT_JAR" ]; then
        CURRENT_VERSION=$(java -cp $MINECRAFT_DIR/$MINECRAFT_JAR net.minecraft.data.Main --version)
        echo "Current Minecraft version: $CURRENT_VERSION"

        if [ "$LATEST_VERSION" != "$CURRENT_VERSION" ]; then
            echo "Updating Minecraft server..."
            rm $MINECRAFT_DIR/$MINECRAFT_JAR
        else
            echo "Minecraft server is up to date."
            return
        fi
    else
        echo "Downloading Minecraft server..."
    fi

    wget -q -O $MINECRAFT_DIR/$MINECRAFT_JAR "https://launcher.mojang.com/v1/objects/$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | grep -A 3 "\"id\": \"$LATEST_VERSION\"" | grep -oP '(?<="url": ")[^"]*')"
}


# Function to install Java if not present
install_java() {
    if ! command -v java &>/dev/null; then
        echo "Java not found. Installing OpenJDK..."
        sudo apt-get update
        sudo apt-get install -y openjdk-11-jdk
    fi
}

# Function to configure server properties
configure_server() {
    echo "Configuring server properties..."
    sudo echo "eula=true" > ~/minecraft/eula.txt
    sudo echo "motd=Forge Gaming LAN 20 Server" > ~/minecraft/server.properties
    sudo echo "gamemode=0" >> ~/minecraft/server.properties 
    sudo echo "hardcore=false" >> ~/minecraft/server.properties
}

# Function to start the Minecraft server
start_server() {
    echo "Starting Minecraft server..."
    cd ~/minecraft
    /usr/bin/java -jar ~/minecraft/server.jar nogui
}

# Main script
if [ ! -f "~/minecraft/$MINECRAFT_JAR" ]; then
    echo "Downloading Minecraft server..."
    mkdir -p ~/minecraft
    check_update
else
    echo "Minecraft server found."
    check_update
fi

install_java
configure_server
start_server
