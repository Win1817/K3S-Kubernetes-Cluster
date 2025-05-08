#!/bin/bash

# Function to uninstall Rancher
uninstall_rancher() {
  NAMESPACE="cattle-system"

  echo "Uninstalling Rancher..."
  helm uninstall rancher -n $NAMESPACE
  kubectl delete namespace $NAMESPACE
}

# Function to uninstall cert-manager
uninstall_cert_manager() {
  echo "Uninstalling cert-manager..."
  helm uninstall cert-manager -n cert-manager
  kubectl delete -f https://github.com/jetstack/cert-manager/releases/download/v1.5.3/cert-manager.crds.yaml
  kubectl delete namespace cert-manager
}

# Function to clean up Helm repos
cleanup_helm_repos() {
  echo "Removing Helm repositories..."
  helm repo remove rancher-stable || true
  helm repo remove jetstack || true
}

# Confirm uninstallation
read -p "This will uninstall Rancher and cert-manager from your K3s cluster. Proceed? (yes/no): " confirmation
if [ "$confirmation" = "yes" ]; then
  uninstall_rancher
  uninstall_cert_manager
  cleanup_helm_repos
  echo "Uninstallation complete."
else
  echo "Uninstallation cancelled."
fi
