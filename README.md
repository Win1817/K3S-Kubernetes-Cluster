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
git clone https://github.com/Win1817/K3S-Kubernetes-Cluster.git
cd K3S-Kubernetes-Cluster
````


### 2. Setup K3s Server
Run the setup_k3s_server.sh script to install and configure the K3s server:
````bash
chmod +x setup_k3s_server.sh
./setup_k3s_server.sh
````

### 3. Setup K3s Agent
Run the setup_k3s_agent.sh script on each agent node to join it to the K3s server:
````bash
chmod +x setup_k3s_agent.sh
./setup_k3s_agent.sh
````
Enter the K3s server IP and token when prompted. The script will download K3s, create a systemd service for the agent, and start the agent service.

Verify the Installation
After setting up the K3s server, you can verify the installation by running:
````bash
kubectl get nodes
````

This should display the nodes in your Kubernetes cluster.

License

This project is licensed under the MIT License. See the LICENSE file for details.

Contributing
If you would like to contribute to this project, please fork the repository and submit a pull request.

Issues
If you encounter any issues or have any questions, please open an issue in this repository.
