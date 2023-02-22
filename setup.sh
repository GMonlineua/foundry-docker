#!/bin/bash

username=$(whoami)
path="/home/foundrydata"

sudo apt update && sudo apt upgrade -y
sudo apt install -y zip unzip nano wget docker.io openssh-server

# Foundry user
sudo useradd -m foundrydata
echo -e "\nPassword ftp user"
sudo passwd foundrydata

# Foundry certificate
sudo mkdir $path/ssl
sudo mkdir $path/Config
sudo wget https://raw.githubusercontent.com/GMonlineua/foundry-docker/master/options.json
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $path/ssl/foundry-selfsigned.key -out $path/ssl/foundry-selfsigned.crt

#Foundry docker
sudo usermod -a -G docker $username
read -p ">>> Insert foundry download link: " flink
mkdir -p ~/docker-fvtt/foundryvtt
wget -O foundryvtt.zip "$flink"
unzip foundryvtt.zip -d ~/docker-fvtt/foundryvtt
rm foundryvtt.zip

sudo wget https://raw.githubusercontent.com/GMonlineua/foundry-docker/master/Dockerfile -o ~/docker-fvtt/Dockerfile
sudo docker build -t foundryvtt ~/docker-fvtt/
sudo docker run -d --name foundry -p 443:443 -v $path:/home/node -it foundryvtt:latest

sudo chown -R foundrydata $path

echo "Please reboot"
