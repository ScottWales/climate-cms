# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "chef/centos-6.6"
  config.vm.provision "shell", path: "startup.sh"

  config.vm.define "backend" do |node|
      node.vm.hostname = "backend"
      node.vm.provision "shell", path: "bootstrap.sh"
  end
  config.vm.define "frontend" do |node|
  end

end
