# Vagrant and Kubernetes from apt
This project has code to use Vagrant to launch VMs in your workstation, and, in them, install Kubernetes from the apt repositories. 
## Overview 
- A Vagrant script (filename: `Vagrantfile`) contains the code to launch the VMs. 
- Bash scripts `master.sh`, `worker.sh`, `common.sh` are referenced by Vagrantfile to install software and apply settings.
- In `Vagrantfile`, go to line 46, where it says `(1..3).each do |i|`, this is a loop. It's launching 3 VMs to be used as cluster worker nodes. You can change this "3" to a higher or lower number. Minimum 1. 
- Through a file share with your workstation, the VM running as master Kubernetes node will write into your project directory, into file `share\join-command` the cluster join command and token. This file is read by the worker VMs so they can join. If you manually provision other machines you can use this cluster join command.
## Instructions
1. Install [Virtualbox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](https://developer.hashicorp.com/vagrant/downloads)
3. Download this project and get in the project's directory.
4. Run command `vagrant up` to provision the VMs in your workstation. 
5. Run command `vagrant ssh master1` to login to the VM which is the master cluster node. 
6. While in the master node, start playing:
```
kubectl get nodes
kubectl version
kubectl get all --all-namespaces
kubectl apply -f ...
``` 
Running `kubectl get nodes` notice how you have a cluster with 3 worker nodes. Unless you changed that "3" above. 
Once you are done, destroy these local VMs with `vagrant destroy`.

The process of Kubernetes installation through apt is an automation of the manual process described here:
https://devopscube.com/setup-kubernetes-cluster-kubeadm/
