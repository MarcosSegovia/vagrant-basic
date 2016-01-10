# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise32"

  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  config.vm.network "private_network", ip: "192.168.33.19"
  #config.vm.network :forwarded_port, host: 8080, guest: 80

  ################
  ##  PUPPET #####
  ################
  config.vm.provision :puppet,
    :options => ["--fileserverconfig=fileserver.conf"],
    :facter => { "fqdn" => "vagrant.vagrantup.com" }  do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file = "manifest.pp"
  end

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  ################
  ##  SHARED #####
  ################
  # config.vm.synced_folder "../data", "/vagrant_data"
  #config.vm.synced_folder "./shared/www", "/www", :mount_options => ["dmode=777,fmode=777"]
  config.vm.synced_folder "./public", "/var/www/html"
  #config.vm.synced_folder "./db", "/var/sqldump", create: true

  config.vm.provision :shell, :path => "install.sh"

end
