
Vagrant.configure("2") do |config|

    config.vm.box = "bento/ubuntu-24.04"
    config.vm.box_version = "202510.26.0"
    config.vm.box_architecture = "amd64"

  config.vm.provider "vmware_desktop" do |vmware|
    vmware.gui = false

    vmware.vmx["memsize"] = "1024"
    vmware.vmx["numvcpus"] = "1"
  end

  # Manager Node
  config.vm.define "swarm-manager" do |manager|
    manager.vm.hostname = "swarm-manager"
    manager.vm.network "private_network", ip: "192.168.186.10"
  end

  # Worker Node 1
  config.vm.define "swarm-worker1" do |worker1|
    worker1.vm.hostname = "swarm-worker1"
    worker1.vm.network "private_network", ip: "192.168.186.11"
  end

  # Worker Node 2
  config.vm.define "swarm-worker2" do |worker2|
    worker2.vm.hostname = "swarm-worker2"
    worker2.vm.network "private_network", ip: "192.168.186.12"
  end

end
