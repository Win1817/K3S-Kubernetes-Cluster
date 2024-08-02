# Kubernetes Project Setup with K3s

This repository contains scripts and configurations for setting up a lightweight Kubernetes cluster using K3s. The repository includes scripts to automate the installation and configuration of both K3s servers and agents, making it easy to deploy and manage a K3s cluster.

## Key Features

- Automated K3s server and agent installation and configuration
- Customizable server IP and token
- Systemd service creation for K3s server and agent
- Easy setup of kubeconfig for `kubectl`
- Display of K3s node token for joining additional nodes

## Prerequisites

- A Linux machine with `curl` installed
- Sudo privileges on the machine
- Internet connection to download K3s

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/your-repo-name.git
cd your-repo-name
