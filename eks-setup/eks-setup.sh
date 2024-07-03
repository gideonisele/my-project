#!/bin/bash

# Function to print status messages
print_status() {
    echo "========================================"
    echo "$1"
    echo "========================================"
}

# Update the system
print_status "Updating the system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install unzip -y

# Install AWS CLI V2
print_status "Installing AWS CLI V2..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version

# Install eksctl
print_status "Installing eksctl..."
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

# Install kubectl
print_status "Installing kubectl..."
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client

# Clean up downloaded files
print_status "Cleaning up..."
rm awscliv2.zip
rm -rf aws
rm eksctl_*.tar.gz

print_status "Installation complete! AWS CLI V2, eksctl, and kubectl are now installed."
