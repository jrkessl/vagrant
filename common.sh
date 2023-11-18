#!/bin/bash
echo ""
echo "### Starting common script"

echo ""
echo "### Step 1 - Forwarding IPv4 and letting iptables see bridged traffic" 
echo ""
echo "### Step 1.1 - cat into modules-load.d/k8s.conf" 
cat <<EOF |   tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
echo ""
echo "### Step 1.2 - modprobes" 
  modprobe overlay
  modprobe br_netfilter
echo ""
echo "### Step 1.3 - cat into sysctl.d/k8s.conf" 
cat <<EOF |   tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
echo ""
echo "### Step 1.4 - sysctl" 
  sysctl --system

echo ""
echo "### Step 2 - Install containerd runtime" 
echo ""
echo "### Step 2.1 - Add Docker's official GPG key"
  apt-get update
  apt-get install ca-certificates curl gnupg -y
  install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg |   gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  chmod a+r /etc/apt/keyrings/docker.gpg
echo ""
echo "### Step 2.2 - Add the repository to Apt sources"
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get update
echo ""
echo "### Step 2.3 - Install"
  apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y


echo ""
echo "### Create alias"
echo "alias k=kubectl" >> /home/vagrant/.bashrc
echo "alias k=kubectl" >> /root/.bashrc

echo ""
echo "### End of common script"
