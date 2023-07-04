Vagrant.configure("2") do |config|
  config.vm.provision "shell", inline: <<-SHELL
      apt-get update -y
      echo "192.168.56.11  master1" >> /etc/hosts
      echo "192.168.56.21  worker1" >> /etc/hosts
      echo "192.168.56.22  worker2" >> /etc/hosts
  SHELL

  config.vm.synced_folder "./share", "/vagrant", disabled: false, create: true
  # config.vm.synced_folder "/tmp", "/tmp"
  
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

  config.vm.define "worker1" do |worker1|
    worker1.vm.box = "bento/ubuntu-22.04"
    worker1.vm.hostname = "worker1"
    worker1.vm.network "private_network", ip: "192.168.56.21"
    worker1.vm.provider "virtualbox" do |vb|
        vb.memory = 2048
        vb.cpus = 2
    end
    worker1.vm.provision "shell",
    path: "worker.sh"
  end

  config.vm.define "worker2" do |worker2|
    worker2.vm.box = "bento/ubuntu-22.04"
    worker2.vm.hostname = "worker2"
    worker2.vm.network "private_network", ip: "192.168.56.22"
    worker2.vm.provider "virtualbox" do |vb|
        vb.memory = 2048
        vb.cpus = 2
    end
    worker2.vm.provision "shell",
    path: "worker.sh"
  end

  
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


# check:
# https://devopscube.com/setup-kubernetes-cluster-kubeadm/


