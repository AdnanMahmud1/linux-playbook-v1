#!/bin/bash

log  ".........Creating Watchtower Docker Container...Step 2"
# Run Watchtower with a 30-minute schedule and cleanup option
docker run -d \
  --name watchtower \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower \
  --debug \
  --cleanup \
  --schedule "*/30 * * * *"
