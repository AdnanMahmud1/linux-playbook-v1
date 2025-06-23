#!/bin/bash

# This script configures DNS and merges LVM storage in Proxmox
# Warning: Use with caution, especially the lvremove part

set -e

echo "Removing logical volume /dev/pve/data..."
lvremove /dev/pve/data -y

echo "Resizing root volume to use all free space..."
lvresize -l +100%FREE /dev/pve/root

echo "Resizing filesystem..."
resize2fs /dev/mapper/pve-root

echo "Done. Please verify everything is working correctly."
