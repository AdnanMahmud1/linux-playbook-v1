#!/bin/bash
# Log file path
LOGFILE="script.log"

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to log messages with color
log() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
    echo "${message}" >> $LOGFILE
}


log $YELLOW ".........Starting Linux Update"
apt update && apt upgrade -y
log $GREEN ".........Completed: Linux update"


sleep 3
log $YELLOW ".........Starting Docker Installation Phase-1"

sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
log $GREEN ".........Completed: Docker Installation Phase-1"

sleep 3
# ----------  Phase-2 (fixed)  ----------
log $YELLOW ".........Starting Docker installation Phase-2"

# 1. Make sure we have the current OS version string
. /etc/os-release
CODENAME=$(lsb_release -cs || echo "$VERSION_CODENAME")

# 2. Add the official Docker repo (forces current codename)
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu ${CODENAME} stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

# 3. Refresh package list **after** adding the new repo
sudo apt-get update -y

# 4. Install the latest Docker packages
sudo apt-get install -y \
  docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

log $GREEN ".........Completed: Docker installation Phase-2"
# ---------------------------------------
# sleep 1
# log $YELLOW ".........Adding Doker to Sudoers..."
# sudo groupadd docker
# sudo usermod -aG docker $USER
# newgrp docker
# log $GREEN "Completed: Adding Doker "

sleep 3
log $GREEN ".........Running Hello World"
sudo docker run hello-world
