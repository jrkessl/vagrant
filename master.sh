#!/bin/bash
echo ""
echo "### Starting master script"


kubeadm config images pull

# Get the local IP of this master node (but we know already it's 192.168.56.11. It's been hardcoded in the Vagrant file).
local_ip="$(ip --json a s | jq -r '.[] | if .ifname == "eth1" then .addr_info[] | if .family == "inet" then .local else empty end else empty end')"

# Get the node name (even if we already know its 'master1'. It's been hardcoded in the Vagrantfile).
NODENAME=$(hostname -s)

# Initialize it 
kubeadm init --pod-network-cidr="10.0.0.0/16" --apiserver-advertise-address=$local_ip --node-name $NODENAME

# Make my kubeconfig file 
# For root user
mkdir -p /root/.kube
sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config
# For vagrant user
mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
# sudo chown $(id -u):$(id -g) /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/config
echo "alias k=kubectl" >> /home/vagrant/.bashrc
echo "alias k=kubectl" >> /root/.bashrc

# Save join command
kubeadm token create --print-join-command > /vagrant/join-command
sudo chmod 777 /vagrant/join-command

# Install pod network (skipped)
# kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

echo ""
echo "### End of master script"
