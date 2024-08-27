#!/bin/bash

# Function to install Helm
install_helm() {
  if ! command -v helm &> /dev/null; then
    echo "Helm not found, installing Helm..."
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
  else
    echo "Helm is already installed."
  fi
}

# Function to install Rancher
install_rancher() {
  # Set variables
  NAMESPACE="cattle-system"

  # Prompt for host IP address and set hostname
  read -p "Enter the host IP address: " HOST_IP
  HOSTNAME="rancher.${HOST_IP}.nip.io"

  # Create a namespace for Rancher
  kubectl create namespace $NAMESPACE

  # Add the Helm chart repository
  helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
  helm repo update

  # Install cert-manager (required by Rancher)
  kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.5.3/cert-manager.crds.yaml
  kubectl create namespace cert-manager
  helm repo add jetstack https://charts.jetstack.io
  helm repo update
  helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.5.3

  # Wait for cert-manager to be ready
  kubectl -n cert-manager rollout status deploy/cert-manager
  kubectl -n cert-manager rollout status deploy/cert-manager-webhook
  kubectl -n cert-manager rollout status deploy/cert-manager-cainjector

  # Install Rancher using Helm
  helm install rancher rancher-stable/rancher \
    --namespace $NAMESPACE \
    --set hostname=$HOSTNAME \
    --set replicas=1

  # Wait for Rancher to be ready
  kubectl -n $NAMESPACE rollout status deploy/rancher

  echo "Rancher installation is complete. Access it at https://$HOSTNAME"
}

# Confirm installation
read -p "This script will install Rancher in your K3s cluster. Do you want to proceed? (yes/no): " confirmation
if [ "$confirmation" = "yes" ]; then
  install_helm
  install_rancher
else
  echo "Installation cancelled."
fi

kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: rancher-nodeport
  namespace: cattle-system
spec:
  type: NodePort
  selector:
    app: rancher
  ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30080
    - name: https
      protocol: TCP
      port: 443
      targetPort: 443
      nodePort: 30443
EOF
