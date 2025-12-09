#!/bin/bash
# ------------------------------------------------------------
#  Docker CE installer for Ubuntu / Debian
#  – always pulls the current repo key
#  – uses the rolling repository name
#  – coloured logging to terminal + script.log
# ------------------------------------------------------------

LOGFILE="script.log"

# ---------- colours ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Colour

# ---------- logging helper ----------
log() {
    local colour=$1
    local message=$2
    echo -e "${colour}${message}${NC}"
    printf '%s\n' "$message" >> "$LOGFILE"
}

# ---------- need to be root or sudo ----------
if [[ $EUID -ne 0 ]] && ! sudo -n true 2>/dev/null; then
    log "$RED" "This script must run as root or with password-less sudo. Aborting."
    exit 1
fi

# ---------- 1.  OS update ----------
log "$YELLOW" ".........Starting OS update"
sudo apt-get update -qq && sudo apt-get upgrade -y -qq >>"$LOGFILE" 2>&1
log "$GREEN" ".........OS update complete"

# ---------- 2.  Install pre-reqs & refresh Docker key ----------
log "$YELLOW" ".........Installing pre-requisites & refreshing Docker key"
sudo apt-get install -y -qq ca-certificates curl gnupg lsb-release >>"$LOGFILE" 2>&1

sudo install -m 0755 -d /etc/apt/keyrings
# always fetch the current key (may have rotated)
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
     sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# ---------- 3.  Add the rolling repo ----------
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt-get update -qq >>"$LOGFILE" 2>&1
log "$GREEN" ".........Docker repository configured"

# ---------- 4.  Install Docker ----------
log "$YELLOW" ".........Installing Docker packages"
sudo apt-get install -y -qq \
     docker-ce docker-ce-cli containerd.io \
     docker-buildx-plugin docker-compose-plugin >>"$LOGFILE" 2>&1
log "$GREEN" ".........Docker packages installed"

# ---------- 5.  Enable & start ----------
sudo systemctl enable docker >>"$LOGFILE" 2>&1
sudo systemctl start docker  >>"$LOGFILE" 2>&1

# ---------- 6.  Quick sanity check ----------
log "$YELLOW" ".........Running hello-world container"
if sudo docker run --rm hello-world >>"$LOGFILE" 2>&1; then
    log "$GREEN" ".........Docker is working!"
else
    log "$RED" ".........Docker install succeeded but hello-world failed – check logs."
    exit 1
fi

log "$GREEN" "=== All done – Docker CE installed and functional ==="
