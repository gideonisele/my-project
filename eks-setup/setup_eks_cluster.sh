#!/bin/bash

# Prerequisite for running this script
# 1. Generate a new SSH key pair:
# ssh-keygen -t rsa -b 2048 -f ~/.ssh/eks-key
# This will create two files: ~/.ssh/eks-key (private key) and ~/.ssh/eks-key.pub (public key).
# 2. Upload the public key to your AWS account:
# aws ec2 import-key-pair --key-name "eks-key" --public-key-material file://~/.ssh/eks-key.pub
# Create an IAM user eksadmin with Administrative access and acess and secret key
# Login using the credentials
# aws configure



# Function to print status messages
print_status() {
 echo "========================================"
 echo "$1"
 echo "========================================"
}

# Define variables for the cluster
CLUSTER_NAME="my-eks-cluster"
REGION="us-east-1"
NODEGROUP_NAME="standard-workers"
NODE_TYPE="t3.micro"
NODES=2
MIN_NODES=1
MAX_NODES=4
SSH_KEY_NAME="eks-key"

# Set AWS Credentials before script Execution
aws sts get-caller-identity >> /dev/null
if [ $? -eq 0 ]
then
 echo "Credentials tested, Proceeding with the cluster creation."

# Create EKS cluster
print_status "Creating EKS cluster with eksctl..."
eksctl create cluster \
  --name $CLUSTER_NAME \
  --region $REGION \
  --nodegroup-name $NODEGROUP_NAME \
  --node-type $NODE_TYPE \
  --nodes $NODES \
  --nodes-min $MIN_NODES \
  --nodes-max $MAX_NODES \
  --node-volume-size 8 \
  --ssh-access \
  --ssh-public-key $SSH_KEY_NAME \
  --managed

# Check if cluster is created
if [ $? -eq 0 ]
then
 echo "Cluster setup is completed with eksctl command."
else
 echo "Cluster setup failed while running eksctl command."
fi
else
 echo "Please run the AWS Configure to setup the right Credentials"
 echo "Cluster setup failed"
fi