#!/bin/bash
echo ""
echo "### Starting master script"

echo "### Step 1 - Install kubectl (Kubernetes apt repository is already installed)" 
echo ""
sudo apt-get install -y kubectl

# echo ""
# echo "### Install pod network (skipped)"
# # kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

echo ""
echo "### End of master script"
