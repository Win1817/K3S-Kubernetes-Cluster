#!/bin/bash

# Define variables
SERVICE_FILE="/etc/systemd/system/k3s-agent.service"

# Stop and disable the K3s agent service
echo "Stopping and disabling the K3s agent service..."
sudo systemctl stop k3s-agent
sudo systemctl disable k3s-agent

# Remove the systemd service file
echo "Removing systemd service file..."
sudo rm -f "$SERVICE_FILE"

# Remove the K3s binary
echo "Removing K3s binary..."
sudo rm -f /usr/local/bin/k3s

# Clean up K3s data directory
echo "Cleaning up K3s data directory..."
sudo rm -rf /var/lib/rancher/k3s

# Optionally remove K3s configuration files (uncomment if needed)
# echo "Removing K3s configuration files..."
# sudo rm -rf /etc/rancher/k3s

echo "K3s agent has been uninstalled."
