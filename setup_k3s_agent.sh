#!/bin/bash

# Define variables
K3S_VERSION="v1.28.12-rc1+k3s1"
K3S_URL="https://github.com/k3s-io/k3s/releases/download/${K3S_VERSION}/k3s"
SERVICE_FILE="/etc/systemd/system/k3s-agent.service"

# Prompt for server IP and token
read -p "Enter the K3s server IP (e.g., 10.245.0.8): " SERVER_IP
read -p "Enter the K3s token: " TOKEN

# Add K3S
echo "Downloading K3s..."
cd
mkdir -p Kubernetes-Project
cd Kubernetes-Project
curl -LO "$K3S_URL"
chmod +x k3s
sudo mv k3s /usr/local/bin/

# Create a Systemd Service for the K3s Agent
echo "Creating systemd service file..."
sudo tee "$SERVICE_FILE" <<EOF
[Unit]
Description=Lightweight Kubernetes
Documentation=https://k3s.io
After=network-online.target
Wants=network-online.target

[Service]
Type=exec
ExecStart=/usr/local/bin/k3s agent --server=https://$SERVER_IP:6443 --token=$TOKEN
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and Start K3s Agent
echo "Reloading systemd and starting K3s agent..."
sudo systemctl daemon-reload
sudo systemctl start k3s-agent
sudo systemctl enable k3s-agent

# Verify the Installation
echo "Verifying the installation..."
systemctl status k3s-agent
