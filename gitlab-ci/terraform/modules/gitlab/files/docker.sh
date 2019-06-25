#!/bin/bash
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-compose
sudo mkdir -p /srv/gitlab/config /srv/gitlab/data /srv/gitlab/logs
sudo cp /tmp/docker-compose.yml /srv/gitlab/docker-compose.yml
cd /srv/gitlab/
export EXT_IP=$(curl ifconfig.io)
sudo sed -i 's/<YOUR-VM-IP>/'$EXT_IP'/g' docker-compose.yml
sudo docker-compose up -d
