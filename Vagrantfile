Vagrant.configure("2") do |config|
  config.vm.provision "shell", inline: <<-SHELL
      apt-get update -y
      echo "192.168.56.10  master1" >> /etc/hosts
      echo "192.168.56.21  worker1" >> /etc/hosts
      echo "192.168.56.22  worker2" >> /etc/hosts
  SHELL
  
  config.vm.define "master" do |master|
      master.vm.box = "bento/ubuntu-22.04"
      master.vm.hostname = "master1"
      master.vm.network "private_network", ip: "192.168.56.10"
      master.vm.provider "virtualbox" do |vb|
          vb.memory = 2048
          vb.cpus = 2
      end
  end

  config.vm.define "worker1" do |worker1|
      worker1.vm.box = "bento/ubuntu-22.04"
      worker1.vm.hostname = "worker1"
      worker1.vm.network "private_network", ip: "192.168.56.20"
      worker1.vm.provider "virtualbox" do |vb|
          vb.memory = 1024
          vb.cpus = 1
      end
  end

    
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