#!/bin/bash

# Define variables
MINECRAFT_DIR="/path/to/minecraft/server"
MINECRAFT_JAR="server.jar"
JAVA_PATH="/usr/bin/java"  # Path to your Java executable
MEMORY="2G"  # Amount of RAM to allocate to the server

# Function to check for server updates
check_update() {
    echo "Checking for Minecraft server update..."
    wget -q -O current_version.txt https://launchermeta.mojang.com/mc/game/version_manifest.json

    LATEST_VERSION=$(grep -oP '(?<="release": ")[^"]*' current_version.txt)
    CURRENT_VERSION=$(grep -oP '(?<="id": ")[^"]*' $MINECRAFT_DIR/version_manifest.json)

    if [ "$LATEST_VERSION" != "$CURRENT_VERSION" ]; then
        echo "Updating Minecraft server..."
        wget -q -O $MINECRAFT_JAR https://launcher.mojang.com/v1/objects/SHA256HASHHERE/server.jar
    else
        echo "Minecraft server is up to date."
    fi

    rm current_version.txt
}

# Function to start the Minecraft server
start_server() {
    echo "Starting Minecraft server..."
    cd $MINECRAFT_DIR
    $JAVA_PATH -Xmx$MEMORY -Xms$MEMORY -jar $MINECRAFT_JAR nogui
}

# Function to configure server properties
configure_server() {
    echo "Configuring server properties..."
    echo "eula=true" > $MINECRAFT_DIR/eula.txt
    echo "motd=Forge Gaming LAN 20 Server" > $MINECRAFT_DIR/server.properties
    echo "gamemode=0" >> $MINECRAFT_DIR/server.properties
    echo "hardcore=true" >> $MINECRAFT_DIR/server.properties
}

# Main script
if [ ! -f "$MINECRAFT_DIR/$MINECRAFT_JAR" ]; then
    echo "Downloading Minecraft server..."
    mkdir -p $MINECRAFT_DIR
    check_update
else
    echo "Minecraft server found."
    check_update
fi

configure_server
start_server
