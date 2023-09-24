Vagrant.configure("2") do |config|

  if ENV['VAGRANT_ENV'] == 'development'
    puts "yes"
  else
    puts "no"
    puts "VAGRANT_ENV = "
  end


  quant_workers = ENV['QUANT_WORKERS']
  quant_masters = ENV['QUANT_MASTERS']
  # quant_workers = ENV['QUANT_WORKERS'] || 'default_box_name'
  
  # config.vm.provision "shell", inline: <<-SHELL
  #     apt-get update -y
  #     echo "192.168.56.11  master1" >> /etc/hosts
  #     echo "192.168.56.21  worker1" >> /etc/hosts
  #     echo "192.168.56.22  worker2" >> /etc/hosts
  # SHELL

  config.vm.synced_folder "./share", "/vagrant", disabled: false, create: true
  # config.vm.synced_folder "/tmp", "/tmp"

  puts "We will create #{quant_masters} masters."
  puts "We will create #{quant_workers} workers."

  if quant_masters < 1 
    puts "Invalid quantity of masters or workers."
    puts "Quantity of masters: #{quant_masters}"
    puts "Quantity of workers: #{quant_workers}"
    exit
  end

  (1..2).each do |i|
    config.vm.define "master#{i}" do |master1|
      master1.vm.box = "bento/ubuntu-22.04"
      master1.vm.hostname = "master#{i}"
      master1.vm.network "private_network", ip: "192.168.56.1#{i}"
      master1.vm.provider "virtualbox" do |vb|
          vb.memory = 2048
          vb.cpus = 2
      end

      puts "inner block!"

      # master1.vm.provision "shell",
      # # path: "common.sh",
      # # args: "=1.25.14-00" # uncomment this line to install Kubernetes 1.25
      # # args: "=1.26.9-00"  # uncomment this line to install Kubernetes 1.26
      # args: "=1.27.6-00"  # uncomment this line to install Kubernetes 1.27
      # # args: "=1.28.2-00"  # uncomment this line to install Kubernetes 1.28
      # # args: ""              # not passing this parameter means the latest Kubernetes, whatever that is now, will get installed.

      # master1.vm.provision "shell",
      # path: "master.sh"

    end

  end

  # config.vm.define "worker1" do |worker1|
  #   worker1.vm.box = "bento/ubuntu-22.04"
  #   worker1.vm.hostname = "worker1"
  #   worker1.vm.network "private_network", ip: "192.168.56.21"
  #   worker1.vm.provider "virtualbox" do |vb|
  #       vb.memory = 2048
  #       vb.cpus = 2
  #   end

  #   worker1.vm.provision "shell",
  #   # path: "common.sh",
  #   # args: "=1.25.14-00" # uncomment this line to install Kubernetes 1.25
  #   # args: "=1.26.9-00"  # uncomment this line to install Kubernetes 1.26
  #   args: "=1.27.6-00"  # uncomment this line to install Kubernetes 1.27
  #   # args: "=1.28.2-00"  # uncomment this line to install Kubernetes 1.28
  #   # args: ""              # not passing this parameter means the latest Kubernetes, whatever that is now, will get installed.

  #   worker1.vm.provision "shell",
  #   path: "worker.sh"
  # end

end


# check:
# https://devopscube.com/setup-kubernetes-cluster-kubeadm/


