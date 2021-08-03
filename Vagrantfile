# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"


  config.vm.provider "virtualbox" do |v|
    v.memory = 256
    v.cpus = 1
  end

  config.vm.define "rpms" do |rpms|
    rpms.vm.network "private_network", ip: "192.168.50.10", virtualbox__intnet: "net1"
    rpms.vm.hostname = "rpms"
    rpms.vm.provision "shell", path: "rpm_script.sh"
  end

  config.vm.define "rpmc" do |rpmc|
    rpmc.vm.network "private_network", ip: "192.168.50.11", virtualbox__intnet: "net1"
    rpmc.vm.hostname = "rpmc"
    rpmc.vm.provision "shell", path: "rpmclient_script.sh"
  end

end
