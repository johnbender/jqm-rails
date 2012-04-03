# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "base"
  config.vm.network(:hostonly, "33.33.33.10")
  config.vm.forward_port(80, 4567)

  # Share the WWW folder as the main folder for the web VM using NFS
  config.vm.share_folder("v-root", "/vagrant", ".", :nfs => true)

  config.vm.provision :shell, :path => "script/provision.sh"
end
