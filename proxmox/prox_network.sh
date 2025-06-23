#!/bin/bash

# This script configures DNS and merges LVM storage in Proxmox
# Warning: Use with caution, especially the lvremove part

set -e

echo "Updating DNS configuration..."
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
