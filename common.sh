#!/bin/bash
echo ""
echo "### Starting common script"



echo ""
echo "### Step 1 - Forwarding IPv4 and letting iptables see bridged traffic" 
echo ""
echo "### Step 1.1 - cat into modules-load.d/k8s.conf" 
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
echo ""
echo "### Step 1.2 - modprobes" 
modprobe overlay
modprobe br_netfilter
echo ""
echo "### Step 1.3 - cat into sysctl.d/k8s.conf" 
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
echo ""
echo "### Step 1.4 - sysctl" 
sysctl --system

echo "### Step 2 - Disable swap"
swapoff -a
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true
echo ""

echo "### Step 3 - Install cri-o"
cat <<EOF | sudo tee /etc/modules-load.d/crio.conf
overlay
br_netfilter
EOF
# Set up required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system 
OS="xUbuntu_20.04"
VERSION="1.23"
cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /
EOF
cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list
deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /
EOF
curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -
sudo apt-get update
sudo apt-get install cri-o cri-o-runc cri-tools -y
sudo systemctl daemon-reload
sudo systemctl enable crio --now


echo ""
echo "### Step 4 - Install Kubeadm & Kubelet & Kubectl"


echo ""
echo "### Step 4.1 - Install necessary tools"
echo "### Install apt-transport-https, ca-certificates, curl"
sudo apt-get update
sudo apt install apt-transport-https=2.4.9 -y
sudo apt install ca-certificates=20230311ubuntu0.22.04.1 -y
sudo apt install curl=7.81.0-1ubuntu1.10 -y
sudo apt-mark hold apt-transport-https ca-certificates curl

echo ""
echo "### Step 4.2 - Install Kubernetes repository"


# these 3 commands below came from https://github.com/kubernetes/release/issues/2862
sudo mkdir -p /etc/apt/keyrings
echo "deb [signed-by=/etc/apt/keyrings/kubernetes.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes.gpg
# these were the original tutorial commands.
# sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
# echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
# sudo apt-get update


echo ""
echo "### Step 4.3 - Finally install"


sudo apt-get update
sudo apt install kubectl$1 -y 
sudo apt install kubelet$1 -y 
sudo apt install kubeadm$1 -y 
sudo apt-mark hold kubeadm kubelet kubectl

echo ""
echo "### Step 5 - Add the node IP to KUBELET_EXTRA_ARGS."
sudo apt-get install jq=1.6-2.1ubuntu3 -y
local_ip="$(ip --json a s | jq -r '.[] | if .ifname == "eth1" then .addr_info[] | if .family == "inet" then .local else empty end else empty end')"
cat <<EOF | sudo tee /etc/default/kubelet
KUBELET_EXTRA_ARGS=--node-ip=$local_ip
EOF

echo ""
echo "### Step 6 - Just some alias"
echo "alias k=kubectl" >> /home/vagrant/.bashrc
echo "alias k=kubectl" >> /root/.bashrc

echo ""
echo "### End of common script"
