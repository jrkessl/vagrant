#!/bin/bash
echo ""
echo "### Starting master script"

echo ""
echo "### Initialize Kubeadm On Master Node To Setup Control Plane (private IPs)"
IPADDR=$local_ip
NODENAME=$(hostname -s)
POD_CIDR="10.0.0.0/16"
sudo kubeadm init --apiserver-advertise-address=$IPADDR  --apiserver-cert-extra-sans=$IPADDR  --pod-network-cidr=$POD_CIDR --node-name $NODENAME --ignore-preflight-errors Swap

echo ""
echo "### Make my kubeconfig file"
# For root user
mkdir -p /root/.kube
sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config
# For vagrant user
mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
# sudo chown $(id -u):$(id -g) /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/config

echo ""
echo "### Print join command"
kubeadm token create --print-join-command > /vagrant/join-command
sudo chmod 777 /vagrant/join-command

echo ""
echo "### Install pod network (skipped)"
# kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

echo ""
echo "### End of master script"
