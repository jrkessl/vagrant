Vagrant.configure("2") do |config|
  
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

  config.vm.synced_folder "./share", "/vagrant", disabled: false, create: true
  
  config.vm.define "master1" do |master1|
    master1.vm.box = "bento/ubuntu-22.04"
    master1.vm.hostname = "master1"
    master1.vm.network "private_network", ip: "192.168.56.11"
    master1.vm.provider "virtualbox" do |vb|
        vb.memory = 2048
        vb.cpus = 2
    end

    master1.vm.provision "shell",
    path: "common.sh"
    # args: "=1.25.14-00" # uncomment this line to install Kubernetes 1.25
    # args: "=1.26.9-00"  # uncomment this line to install Kubernetes 1.26
    # args: "=1.27.6-00"  # uncomment this line to install Kubernetes 1.27
    # args: "=1.28.2-00"  # uncomment this line to install Kubernetes 1.28
    # args: ""              # not passing this parameter means the latest Kubernetes, whatever that is now, will get installed.

    master1.vm.provision "shell",
    path: "master.sh"

  end


  (1..2).each do |i|
    config.vm.define "worker#{i}" do |worker|
      worker.vm.box = "bento/ubuntu-22.04"
      worker.vm.hostname = "worker#{i}"
      worker.vm.network "private_network", ip: "192.168.56.2#{i}"
      worker.vm.provider "virtualbox" do |vb|
          vb.memory = 2048
          vb.cpus = 2
      end

      worker.vm.provision "shell",
      path: "common.sh"
      # args: "=1.25.14-00" # uncomment this line to install Kubernetes 1.25
      # args: "=1.26.9-00"  # uncomment this line to install Kubernetes 1.26
      # args: "=1.27.6-00"  # uncomment this line to install Kubernetes 1.27
      # args: "=1.28.2-00"  # uncomment this line to install Kubernetes 1.28
      # args: ""              # not passing this parameter means the latest Kubernetes, whatever that is now, will get installed.

      worker.vm.provision "shell",
      path: "worker.sh"
    end
  end

end


# check:
# https://devopscube.com/setup-kubernetes-cluster-kubeadm/


