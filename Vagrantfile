Vagrant.configure("2") do |config|
  
  # This config block is common. Means it will be run for all VMs. 
  config.vm.provision "shell", inline: <<-SHELL
      apt-get update -y
      echo "192.168.56.11  master1" >> /etc/hosts
      echo "192.168.56.12  master2" >> /etc/hosts
      echo "192.168.56.21  worker1" >> /etc/hosts
      echo "192.168.56.22  worker2" >> /etc/hosts
      echo "192.168.56.23  worker3" >> /etc/hosts
      echo "192.168.56.24  worker4" >> /etc/hosts
      echo "192.168.56.25  worker5" >> /etc/hosts
      echo "192.168.56.26  worker6" >> /etc/hosts
      echo "192.168.56.27  worker7" >> /etc/hosts
      echo "192.168.56.28  worker8" >> /etc/hosts
  SHELL

  config.vm.provision "shell",
  # path: "common.sh", args: "=1.25" # uncomment this and pass this argument to install Kubernetes 1.25
  # path: "common.sh", args: "=1.26"  # uncomment this and pass this argument to install Kubernetes 1.26
  # path: "common.sh", args: "=1.27"  # uncomment this and pass this argument to install Kubernetes 1.27
  path: "common.sh", args: "=1.28"  # uncomment this and pass this argument to install Kubernetes 1.28
  # path: "common.sh"                 # uncomment this and pass this argument to install the latest Kubernetes, whatever it is now

  # This line makes so that "share" project folder gets shared with the VMs, in path "/vagrant". 
  config.vm.synced_folder "./share", "/vagrant", disabled: false, create: true
  
  # This is the config for the VM "master1".
  config.vm.define "master1" do |master1|
    master1.vm.box = "bento/ubuntu-22.04"
    master1.vm.hostname = "master1"
    master1.vm.network "private_network", ip: "192.168.56.11"
    master1.vm.provider "virtualbox" do |vb|
        vb.memory = 2048
        vb.cpus = 2
    end

    master1.vm.provision "shell",
    path: "master.sh"

  end

  # This is a loop. With this we can provision N worker nodes. 
  (1..1).each do |i|

    # This is the config for the worker nodes. 
    config.vm.define "worker#{i}" do |worker|
      worker.vm.box = "bento/ubuntu-22.04"
      worker.vm.hostname = "worker#{i}"
      worker.vm.network "private_network", ip: "192.168.56.2#{i}"
      worker.vm.provider "virtualbox" do |vb|
          vb.memory = 2048
          vb.cpus = 2
      end

      worker.vm.provision "shell",
      path: "worker.sh"
    end
  end

end

# check:
# https://devopscube.com/setup-kubernetes-cluster-kubeadm/
