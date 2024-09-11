#!/usr/bin/bash

# Define variables
K3S_VERSION="v1.28.12-rc1+k3s1"
K3S_URL="https://github.com/k3s-io/k3s/releases/download/${K3S_VERSION}/k3s"
SERVICE_FILE="/etc/systemd/system/k3s.service"

# Check if kubectl is installed
echo "Checking if kubectl is installed..."
if ! command -v kubectl &> /dev/null; then
  echo "kubectl not found. Installing kubectl..."
  
  # Install kubectl
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
  echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

  # Move kubectl to /usr/local/bin
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

  echo "kubectl installed successfully."
else
  echo "kubectl is already installed."
fi

# Proceed with K3s installation
echo "Proceeding with K3s installation..."

# Prompt for K3s server options
read -p "Enter the K3s server IP (e.g., 10.245.0.8): " SERVER_IP
read -p "Enter the K3s token (optional, leave empty for auto-generation): " TOKEN

# Add K3S
echo "Downloading K3s..."
cd
mkdir -p Kubernetes-Project
cd Kubernetes-Project
curl -LO "$K3S_URL"
chmod +x k3s
sudo mv k3s /usr/local/bin/

# Create a Systemd Service for the K3s Server
echo "Creating systemd service file..."
if [ -z "$TOKEN" ]; then
  # Token not provided; K3s will generate one automatically
  sudo tee "$SERVICE_FILE" <<EOF
[Unit]
Description=Lightweight Kubernetes
Documentation=https://k3s.io
After=network-online.target
Wants=network-online.target

[Service]
Type=exec
ExecStart=/usr/local/bin/k3s server --bind-address=$SERVER_IP
Restart=always

[Install]
WantedBy=multi-user.target
EOF
else
  # Token provided; use it in the service file
  sudo tee "$SERVICE_FILE" <<EOF
[Unit]
Description=Lightweight Kubernetes
Documentation=https://k3s.io
After=network-online.target
Wants=network-online.target

[Service]
Type=exec
ExecStart=/usr/local/bin/k3s server --bind-address=$SERVER_IP --token=$TOKEN
Restart=always

[Install]
WantedBy=multi-user.target
EOF
fi

# Reload systemd and Start K3s Server
echo "Reloading systemd and starting K3s server..."
sudo systemctl daemon-reload
sudo systemctl start k3s
sudo systemctl enable k3s

# Verify the Installation
echo "Verifying the installation..."
systemctl status k3s

# Wait for K3s to initialize and create necessary files
echo "Waiting for K3s to initialize..."
for i in {1..10}; do
  if sudo [ -f /var/lib/rancher/k3s/server/node-token ]; then
    echo "K3s node token:"
    sudo cat /var/lib/rancher/k3s/server/node-token
    break
  else
    echo "node-token not found, retrying in 10 seconds..."
    sleep 10
  fi
done

# Set up kubeconfig
echo "Setting up kubeconfig..."
if sudo [ -f /etc/rancher/k3s/k3s.yaml ]; then
  sudo mkdir -p ~/.kube
  sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
  sudo chown $(id -u):$(id -g) ~/.kube/config
  export KUBECONFIG=~/.kube/config
  echo "Kubeconfig set up successfully."
else
  echo "k3s.yaml not found, please check K3s installation."
fi
