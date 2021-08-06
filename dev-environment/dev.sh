#!/bin/bash
###############################################################################################
###############################################################################################
#
# This script will install common dev tols
#
# Tested on Ubuntu Server 20.04
#
###############################################################################################
###############################################################################################

echo "------------------"
echo "Updating system and installing pre-requisites "
echo "------------------"

sudo apt-get update
sudo apt install git apt-transport-https ca-certificates curl software-properties-common libssl-dev build-essential -y
sudo apt-get upgrade -y


echo "------------------"
echo "Installing docker and docker compose"
echo "------------------"

sudo su -c 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -'
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update && sudo apt install docker-ce -y
sudo usermod -aG docker $USER
chmod -R 775 ~/docker

sudo su -c 'curl -L https://github.com/docker/compose/releases/download/1.26.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose'
sudo chmod +x /usr/local/bin/docker-compose
mkdir ~/docker
chmod -R 775 ~/docker

echo "------------------"
echo "Installing python environments"
echo "------------------"

sudo apt install python3-virtualenv python3.8-virtualenv -y

echo "------------------"
echo "Installing node.js"
echo "------------------"

sudo apt install nodejs -y
sudo apt install npm -y

echo "------------------"
echo "Installing VS Code, Postman, ngrok via snap"
echo "------------------"

sudo snap install code --classic
sudo snap install postman
snap install ngrok

echo "------------------"
echo "Installing ngrok"
echo "------------------"

sudo snap install code --classic
sudo snap install postman

echo "------------------"
echo "DONE!"
echo "------------------"
