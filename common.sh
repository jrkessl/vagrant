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

echo ""
echo "### Step 2 - Install containerd runtime" 
echo ""
echo "### Step 2.1 - Add Docker's official GPG key"
apt-get update
apt-get install ca-certificates curl gnupg -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo ""
echo "### Step 2.2 - Add the repository to apt sources"
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
echo ""
echo "### Step 2.3 - Install it"
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
echo ""
echo "### Step 2.4 - Set systemd cgroup driver"
cat <<EOF | tee /etc/containerd/config.toml
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true
EOF
systemctl restart containerd
echo ""

echo "### Step 3 - Disable swap"
swapoff -a
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true
echo ""

echo "### Step 4 - Install other tools"
sudo apt-get install -y apt-transport-https gpg # consider specifying the version of such tools. 
echo ""

echo "### Step 5 - Install Kubernetes apt repository"
echo ""
echo "### Step 5.1 - Get the signing key"
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo ""
echo "### Step 5.2 - Add repository"
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
echo ""
echo "### Step 6 - Install kubelet, kubeadm, kubectl"
echo ""
echo "### Step 6.1 - Install them" 
sudo apt-get install -y kubelet kubeadm kubectl
echo "### Step 6.2 - hold them down"
sudo apt-mark hold kubelet kubeadm kubectl
echo ""

echo "### End of common script"
echo ""
