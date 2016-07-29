# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'pathname'

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
VAGRANTFILE_API_VERSION = "2"

git_url           = `git ls-remote --get-url`.strip
git_url_array     = Pathname(git_url).each_filename.to_a
git_group         = git_url_array[-2]
git_project       = git_url_array[-1].sub('.git','')
home_dir          = "/home/vagrant"
target_directory  = "#{home_dir}/#{git_group}"
target_path       = "#{target_directory}/#{git_project}"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.

  # This box contains a basic travis environment
  config.vm.box = 'minimal/trusty64'  
  
  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.  
  config.vm.synced_folder '.', '/vagrant'
  
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Fix for the "stdin: is not a tty" issue.
  # See:  https://github.com/Varying-Vagrant-Vagrants/VVV/issues/517
  config.vm.provision "fix-no-tty", type: "shell" do |s|
      s.privileged = false
      s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end

  # Setup the home environment:
  # 1. Attempt to make the directory structure as similar to travis-ci as possible
  # 2. Ensure that the .oclint file is in the home directory
  # 3. Ensure that `vagrant ssh` places us in the project directory
  config.vm.provision "shell", inline: <<-SHELL
     mkdir -p #{target_directory}
     ln -s /vagrant #{target_path}
     ln -s #{target_path}/.oclint #{home_dir}/.oclint
     sudo -H -u vagrant #{target_path}/bin/dependencies.sh
     echo "cd #{target_path}" >> #{home_dir}/.bashrc
  SHELL
  
  #config.vm.provision "shell", inline: "sudo -H -u vagrant /home/vagrant/github/bin/dependencies.sh"

  #config.vm.provision :file, source: '.oclint', destination: '/home/vagrant/.oclint'
end
