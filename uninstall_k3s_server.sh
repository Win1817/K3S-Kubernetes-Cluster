#!/bin/bash

# Function to uninstall K3s
uninstall_k3s() {
  echo "Stopping K3s service..."
  sudo systemctl stop k3s

  echo "Disabling K3s service..."
  sudo systemctl disable k3s

  echo "Removing K3s binary..."
  sudo rm /usr/local/bin/k3s

  echo "Removing K3s data directories..."
  sudo rm -rf /etc/rancher
  sudo rm -rf /var/lib/rancher

  echo "Removing K3s systemd service file..."
  sudo rm /etc/systemd/system/k3s.service
  sudo systemctl daemon-reload

  echo "Uninstallation of K3s is complete."
}

# Confirm uninstallation
read -p "Are you sure you want to uninstall K3s? (yes/no): " confirmation
if [ "$confirmation" = "yes" ]; then
  uninstall_k3s
else
  echo "Uninstallation cancelled."
fi
