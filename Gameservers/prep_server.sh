#Prep for Steamcmd
sudo add-apt-repository multiverse -y
sudo dpkg --add-architecture i386
sudo sed -i 's/#$nrconf{restart} = '"'"'i'"'"';/$nrconf{restart} = '"'"'a'"'"';/g' /etc/needrestart/needrestart.conf
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt install bsdmainutils bzip2 jq lib32gcc-s1 lib32stdc++6 libcurl4-gnutls-dev:i386 libsdl2-2.0-0:i386 netcat unzip -y
sudo apt install lib32gcc-s1 lib32stdc++6 libc6-i386 libcurl4-gnutls-dev:i386 libsdl2-2.0-0:i386 libncurses5 libncurses5:i386 -y

#Install Steamcmd
echo steam steam/question select "I AGREE" | sudo debconf-set-selections
echo steam steam/license note '' | sudo debconf-set-selections
sudo apt install steamcmd -y

#Manual Process, no longer needed
#sudo mkdir /home/azureuser/Steam && cd /home/azureuser/Steam
#sudo wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
#sudo tar -zxvf steamcmd_linux.tar.gz -C /home/azureuser/Steam