# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Set default provider to libvirt
  ENV["VAGRANT_DEFAULT_PROVIDER"] = "libvirt"

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "base"

  config.vm.define "lmicheliS" do |lmicheliS|
    lmicheliS.vm.box = "aalmenar/debian-13"
    lmicheliS.vm.box_version = "2025.11.19.0519"

    # Private network with persistent IP
    lmicheliS.vm.hostname = "lmicheliS"
    lmicheliS.vm.network "private_network",
      ip: "192.168.56.110",
      type: "static",
      autoconfig: false
    # lmicheliS.vm.provider "libvirt" do |v|
    #   v.management_network_name = "my_network"
    #   v.management_network_address = "192.168.56.110/24"
    #   v.management_network_mac = "52:54:00:fb:95:91"
    # end
    # lmicheliS.vm.network "private_network",
    #   ip: "192.168.56.110"
    #   libvirt__network_name: "vagrant-private-network",
    #   libvirt__dhcp_enabled: false,
    #   libvirt__forward_mode: "none"

    # Libvirt provider configuration
    lmicheliS.vm.provider "libvirt" do |libvirt|
      libvirt.cpus = 1
      libvirt.memory = 1024
    end

    # Sync the Helm chart to the VM
    lmicheliS.vm.synced_folder "./ex02", "/home/vagrant/ex02", type: "rsync", rsync__exclude: ".git/"

    lmicheliS.vm.provision "shell", name: "install-controller", path: "startServer.sh", env: {
      "CONTROLLER_IP" => "192.168.56.110",
      "WORKER_IP" => "192.168.56.111"
    }

    lmicheliS.vm.provision "shell", name: "setup-helm", path: "./ex02/deploy.sh"
  end

  config.vm.define "fracerbaSW" do |fracerbaSW|
    fracerbaSW.vm.box = "aalmenar/debian-13"
    fracerbaSW.vm.box_version = "2025.11.19.0519"

    # Private network with persistent IP
    fracerbaSW.vm.hostname = "fracerbaSW"
    fracerbaSW.vm.network "private_network",
      ip: "192.168.56.111",
      type: "static",
      autoconfig: false
    #   autoconfig: false

    # fracerbaSW.vm.provider "libvirt" do |v|
    #   v.management_network_name = "my_network"
    #   v.management_network_address = "192.168.56.111/24"
    #   v.management_network_mac = "52:54:00:fb:95:92"
    # fracerbaSW.vm.synced_folder "./.k3s", "/home/vagrant/.k3s", create: true
    # end

    # Libvirt provider configuration
    fracerbaSW.vm.provider "libvirt" do |libvirt|
      libvirt.cpus = 1
      libvirt.memory = 1024
    end

    fracerbaSW.vm.provision "shell", name: "install-worker", path: "startClient.sh", env: {
      "CONTROLLER_IP" => "192.168.56.110",
      "WORKER_IP" => "192.168.56.111"
    }
  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Disable the default share of the current code directory. Doing this
  # provides improved isolation between the vagrant box and your host
  # by making sure your Vagrantfile isn't accessable to the vagrant box.
  # If you use this you may want to enable additional shared subfolders as
  # shown above.
  config.vm.synced_folder ".", "/vagrant", disabled: true

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

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
