#!/bin/bash

log  ".........Creating Portainer Docker Container...Step 1"
# Run Portainer container
docker run -d \
  -p 8000:8000 \
  -p 9000:9000 \
  --name=portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce

log  ".........Creating Watchtower Docker Container...Step 2"
# Run Watchtower with a 30-minute schedule and cleanup option
docker run -d \
  --name watchtower \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower \
  --debug \
  --cleanup \
  --schedule "*/30 * * * *"

log  ".........Creating Docker Network...Step 3"
# Create Docker network
docker network create frontend