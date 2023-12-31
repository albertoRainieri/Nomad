ENV['VAGRANT_NO_PARALLEL'] = 'yes'


Vagrant.configure(2) do |config|

  # Consul Server
  config.vm.define "consul" do |node|

    node.vm.box               = "sloopstash/ubuntu-22-04"
    node.vm.box_version       = "2.1.1"
    node.vm.box_check_update  = false
    node.vm.hostname          = "consul.example.com"
    node.vm.network "private_network", ip: "192.168.217.103"
  
    node.vm.provider "vmware_fusion" do |v|
      v.gui     = false
      v.memory  = 2048
      v.cpus    =  2
    end

    node.vm.provision "shell", path: "config/consul_bootstrap.sh"
    
  end

  # Nomad Master Server
  config.vm.define "nmaster" do |node|
  
    node.vm.box               = "sloopstash/ubuntu-22-04"
    node.vm.box_version       = "2.1.1"
    node.vm.box_check_update  = false
    node.vm.hostname          = "nmaster.example.com"
    node.vm.network "private_network", ip: "192.168.217.100"

    node.vm.provider "vmware_fusion" do |v|
      v.gui     = false
      v.memory  = 2048
      v.cpus    =  2
    end
    
    node.vm.provision "shell", path: "config/nomad_bootstrap.sh", args: "192.168.217.100"
    node.vm.provision "shell", path: "config/nomad_master_config.sh"

  end


  # Nomad Worker Nodes
  NodeCount = 2

  (1..NodeCount).each do |i|

    config.vm.define "nclient#{i}" do |node|

      node.vm.box               = "sloopstash/ubuntu-22-04"
      node.vm.box_version       = "2.1.1"
      node.vm.box_check_update  = false
      node.vm.hostname          = "nclient#{i}.example.com"
      node.vm.network "private_network", ip: "192.168.217.10#{i}"

      node.vm.provider "vmware_fusion" do |v|
        v.gui     = false
        v.memory  = 2048
        v.cpus    = 2
      end

      node.vm.provision "shell", path: "config/nomad_bootstrap.sh", args: "192.168.217.10#{i}"
      node.vm.provision "shell", path: "config/nomad_client_config.sh"
    end

  end

end