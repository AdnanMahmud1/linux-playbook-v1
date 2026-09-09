#!/bin/bash

log  ".........Creating Watchtower Docker Container...Step 2"
# Run Watchtower with a 30-minute schedule and cleanup option
docker run -d \
  --name watchtower \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --log-driver json-file \
  --log-opt max-size=10m \
  --log-opt max-file=7 \
  --restart unless-stopped \
  nickfedor/watchtower \
  --cleanup \
  --schedule "*/30 * * * * *"
