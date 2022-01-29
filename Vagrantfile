# -*- mode: ruby -*-
# vi: set ft=ruby :

options = {
  docker_port: ENV['OPT_DOCKER_PORT'] ? ENV['OPT_DOCKER_PORT'].to_i : 2375,
  vm_hostname: ENV['OPT_VM_HOSTNAME'] || 'dockstation',
  vm_ip_addr: ENV['OPT_VM_IP'] || '192.168.56.81',
  vm_mem_mb: ENV['OPT_VM_MEM_MB'] ? ENV['OPT_VM_MEM_MB'].to_i : 2048
}
options[:vm_local_name] = ENV['OPT_VM_LOCALNAME'] || options[:vm_hostname]

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure('2') do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = 'bento/ubuntu-20.04'
  config.vm.hostname = options[:vm_hostname]

  # Set the VM name
  config.vm.define options[:vm_local_name]

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Docker daemon
  config.vm.network 'forwarded_port',
                    guest: options[:docker_port],
                    host: options[:docker_port],
                    id: 'dockerd'

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network 'private_network', ip: options[:vm_ip_addr]

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider 'virtualbox' do |vb|
    # Display the VirtualBox GUI when booting the machine
    # vb.gui = true

    # Customize the amount of memory on the VM:
    vb.memory = options[:vm_mem_mb]
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
  config.vm.provision 'shell',
                      path: 'vagrant-provision.sh',
                      args: [
                        options[:docker_port]    # $1
                      ]

  config.vm.post_up_message = 'Run `source tmp/local-setup.sh` to configure docker.'
end

Dir.mkdir('tmp') unless Dir.exist? 'tmp'
File.write('tmp/local-setup.sh',
           <<~EOT
             # Generated by Vagrantfile config
             # Do not edit
             # Use 'source' load before using docker

             export DOCKER_HOST=tcp://#{options[:vm_ip_addr]}:#{options[:docker_port]}
           EOT
          )