Vagrant.configure("2") do |config|
  config.vm.provision "shell", inline: <<-SHELL
      apt-get update -y
      echo "192.168.56.10  master1" >> /etc/hosts
      echo "192.168.56.20  worker1" >> /etc/hosts
  SHELL

  config.vm.synced_folder "./share", "/vagrant", disabled: false, create: true
  # config.vm.synced_folder "/tmp", "/tmp"
  
  config.vm.define "master" do |master|
    master.vm.box = "bento/ubuntu-22.04"
    master.vm.hostname = "master1"
    master.vm.network "private_network", ip: "192.168.56.10"
    master.vm.provider "virtualbox" do |vb|
        vb.memory = 2048
        vb.cpus = 2
    end
    master.vm.provision "shell",
    path: "master.sh"
  end

  # config.vm.define "worker1" do |master|
  #   master.vm.box = "bento/ubuntu-22.04"
  #   master.vm.hostname = "worker1"
  #   master.vm.network "private_network", ip: "192.168.56.20"
  #   master.vm.provider "virtualbox" do |vb|
  #       vb.memory = 2048
  #       vb.cpus = 2
  #   end
  #   # master.vm.provision "shell",
  #   # path: "worker.sh"
  # end

  
#   config.vm.define "worker1" do |worker1|
#       worker1.vm.box = "bento/ubuntu-22.04"
#       worker1.vm.hostname = "worker1"
#       worker1.vm.network "private_network", ip: "192.168.56.20"
#       worker1.vm.provider "virtualbox" do |vb|
#           vb.memory = 1024
#           vb.cpus = 1
#       end
#   end

    
  # (1..2).each do |i|

  # config.vm.define "node0#{i}" do |node|
  #   node.vm.box = "bento/ubuntu-22.04"
  #   node.vm.hostname = "worker#{i}"
  #   node.vm.network "private_network", ip: "192.168.56.2#{i}"
  #   node.vm.provider "virtualbox" do |vb|
  #       vb.memory = 1024
  #       vb.cpus = 1
  #   end
  # end
  
  # end
end



# cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
# overlay
# br_netfilter
# EOF
# sudo modprobe overlay
# sudo modprobe br_netfilter
# cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
# net.bridge.bridge-nf-call-iptables  = 1
# net.bridge.bridge-nf-call-ip6tables = 1
# net.ipv4.ip_forward                 = 1
# EOF
# sudo sysctl --system
# # disable swap
# sudo swapoff -a
# (crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true
# # install cri-o
# cat <<EOF | sudo tee /etc/modules-load.d/crio.conf
# overlay
# br_netfilter
# EOF
# # Set up required sysctl params, these persist across reboots.
# cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
# net.bridge.bridge-nf-call-iptables  = 1
# net.ipv4.ip_forward                 = 1
# net.bridge.bridge-nf-call-ip6tables = 1
# EOF
# sudo modprobe overlay
# sudo modprobe br_netfilter
# cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
# net.bridge.bridge-nf-call-iptables  = 1
# net.ipv4.ip_forward                 = 1
# net.bridge.bridge-nf-call-ip6tables = 1
# EOF
# sudo sysctl --system 
# OS="xUbuntu_20.04"
# VERSION="1.23"
# cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
# deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /
# EOF
# cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list
# deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /
# EOF
# curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -
# curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -
# sudo apt-get update
# sudo apt-get install cri-o cri-o-runc cri-tools -y
# sudo systemctl daemon-reload
# sudo systemctl enable crio --now

# echo "Install Kubeadm & Kubelet & Kubectl on all Nodes"
# sudo apt-get update
# sudo apt install apt-transport-https=2.4.9 -y
# sudo apt install ca-certificates=20230311ubuntu0.22.04.1 -y
# sudo apt install curl=7.81.0-1ubuntu1.10 -y
# sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

# sudo apt install kubectl=1.25.7-00 -y 
# sudo apt install kubelet=1.25.7-00 -y 
# sudo apt install kubeadm=1.25.7-00 -y 
# sudo apt-mark hold kubeadm kubelet kubectl



# check:
# https://devopscube.com/setup-kubernetes-cluster-kubeadm/

