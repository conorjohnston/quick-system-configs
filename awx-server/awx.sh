#!/bin/bash
###############################################################################################
###############################################################################################
#
# AWX provides a web-based user interface, REST API, and task engine built on top of Ansible.
# It is the upstream project for Tower, a commercial derivative of AWX.
#
# This script will install Docker, Docker-Compose, Ansible and AWX
# Tested on Ubuntu Server 20.04
#
###############################################################################################
###############################################################################################

echo "Please enter AWX username to configure"
read ADMIN
echo "Please enter AWX password to apply"
read -s PASSWORD

echo "------------------"
echo "Updating System "
echo "------------------"

sudo apt-get update
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
sudo apt-get upgrade -y

echo "------------------"
echo "Installing Docker"
echo "------------------"

sudo su -c 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -'
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update && sudo apt install docker-ce -y
sudo usermod -aG docker $USER
newgrp docker

echo "------------------"
echo "Installing Docker Compose"
echo "------------------"

sudo su -c 'curl -L https://github.com/docker/compose/releases/download/1.26.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose'
sudo chmod +x /usr/local/bin/docker-compose
mkdir ~/docker
chmod -R 775 ~/docker

echo "------------------"
echo "Installing Ansible"
echo "------------------"

sudo apt update
sudo apt install ansible -y

echo "------------------"
echo "Installing AWX"
echo "------------------"

sudo apt install nodejs npm -y
sudo npm install npm --global -y
sudo apt install python3-pip git pwgen -y
sudo pip3 install requests==2.20
sudo pip3 install docker
sudo pip3 install docker-compose==1.26

cd ~/
git clone --depth 50 https://github.com/ansible/awx.git

cd ~/awx/installer/
cat <<EOF > inventory
localhost ansible_connection=local ansible_python_interpreter="/usr/bin/env python3"
[all:vars]
dockerhub_base=ansible
awx_task_hostname=awx
awx_web_hostname=awxweb
postgres_data_dir="~/.awx/pgdocker"
host_port=80
host_port_ssl=443
docker_compose_dir="~/.awx/awxcompose"
pg_username=awx
pg_password=awxpass
pg_database=awx
pg_port=5432
admin_user=$ADMIN
admin_password=$PASSWORD
create_preload_data=True
EOF

echo "secret_key=$(pwgen -N 1 -s 30)" >> inventory

sudo ansible-playbook -i inventory install.yml
