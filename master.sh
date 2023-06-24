#!/bin/bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system
# disable swap
sudo swapoff -a
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true
# install cri-o
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
sudo modprobe overlay
sudo modprobe br_netfilter
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

echo "Install Kubeadm & Kubelet & Kubectl on all Nodes"
sudo apt-get update
sudo apt install apt-transport-https=2.4.9 -y
sudo apt install ca-certificates=20230311ubuntu0.22.04.1 -y
sudo apt install curl=7.81.0-1ubuntu1.10 -y
sudo apt-mark hold apt-transport-https ca-certificates curl

# estes 3 comandos abaixo vieram deste link: 
# https://github.com/kubernetes/release/issues/2862
sudo mkdir -p /etc/apt/keyrings
echo "deb [signed-by=/etc/apt/keyrings/kubernetes.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes.gpg
    # tee: só salva o output no arquivo
    # curl: só baixa mesmo, o conteúdo.
    # gpg: salva o conteúdo recebido na forma "dearmored" (forma binária) no arquivo passado.

# esses abaixo são os comandos originais do tutorial. Eles não salvam a chave em formato binário.
# sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
# echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
# sudo apt-get update

sudo apt-get update
sudo apt install kubectl=1.25.7-00 -y 
sudo apt install kubelet=1.25.7-00 -y 
sudo apt install kubeadm=1.25.7-00 -y 
sudo apt-mark hold kubeadm kubelet kubectl

echo "Add the node IP to KUBELET_EXTRA_ARGS."
sudo apt-get install jq=1.6-2.1ubuntu3 -y
local_ip="$(ip --json a s | jq -r '.[] | if .ifname == "eth1" then .addr_info[] | if .family == "inet" then .local else empty end else empty end')"
cat <<EOF | sudo tee /etc/default/kubelet
KUBELET_EXTRA_ARGS=--node-ip=$local_ip
EOF

echo ""
echo "### Initialize Kubeadm On Master Node To Setup Control Plane (private IPs)"
IPADDR=$local_ip
NODENAME=$(hostname -s)
POD_CIDR="10.0.0.0/16"
sudo kubeadm init --apiserver-advertise-address=$IPADDR  --apiserver-cert-extra-sans=$IPADDR  --pod-network-cidr=$POD_CIDR --node-name $NODENAME --ignore-preflight-errors Swap

echo ""
echo "### Make my kubeconfig file"
mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
# sudo chown $(id -u):$(id -g) /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/config

echo ""
echo "### Create alias"
echo "alias k=kubectl" >> /home/vagrant/.bashrc

# mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo ""
echo "### Print join command"
kubeadm token create --print-join-command > /vagrant/join-command
sudo chmod 777 /vagrant/join-command

echo ""
echo "### Install pod network"
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml