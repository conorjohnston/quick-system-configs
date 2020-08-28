#!/bin/bash
###############################################################################################
###############################################################################################
#
# This script will install Docker, Docker-Compose, Plex, Portainer, Tautilli and watchtower
#
# Tested on Ubuntu Server 20.04
#
###############################################################################################
###############################################################################################

echo "------------------"
echo "Updating System "
echo "------------------"

sudo apt-get update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
sudo apt-get upgrade -y


echo "------------------"
echo "Installing Docker"
echo "------------------"

sudo su -c 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -'
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update && sudo apt install docker-ce -y
sudo usermod -aG docker $USER
chmod -R 775 ~/docker


echo "------------------"
echo "Installing Docker Compose"
echo "------------------"

sudo su -c 'curl -L https://github.com/docker/compose/releases/download/1.26.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose'
sudo chmod +x /usr/local/bin/docker-compose
mkdir ~/docker
chmod -R 775 ~/docker

echo "------------------"
echo "Starting Media Services"
echo "------------------"

sudo docker-compose -f ~/quick-vm-configs/media-server/media-stack.yml up -d

echo "------------------"
echo "DONE!"
echo "------------------"
echo ""
echo "Media services now up and running...

Portainer: http://$(hostname -I | awk '{ print $1 }'):9000 - Docker Container Management UI.
Plex: http://$(hostname -I | awk '{ print $1 }'):32400/web -  Personal Media Server
Tautilli: http://$(hostname -I | awk '{ print $1 }'):8181 -  Monitoring tool for Plex
"
