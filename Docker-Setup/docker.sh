#!/bin/bash
# Log file path
LOGFILE="script.log"

echo "Starting script..." | tee -a $LOGFILE
apt update && apt upgrade -y


sleep 1
echo "Starting Docker Installation Phase-1..." | tee -a $LOGFILE

sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "Completed: Docker Installation Phase-1" | tee -a $LOGFILE

sleep 1
echo "Starting Docker installation Phase-2" | tee -a $LOGFILE
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "Completed: Docker Installation Phase-2" | tee -a $LOGFILE

sleep 1
echo "Adding Doker to Sudoers..." | tee -a $LOGFILE
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
echo "Completed: Adding Doker " | tee -a $LOGFILE

sleep 1
echo "Running Hello World" | tee -a $LOGFILE

sudo docker run hello-world