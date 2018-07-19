# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2".freeze

server_os = 'ubuntu/trusty64'
host1_os = 'ubuntu/trusty64'

server = [
	{box: server_os.to_s, name: 'chef-server', hostname: 'chef-server', memory: '4096', ip: '10.2.1.10', provision: 'provision.sh'},
    {box: server_os.to_s, name: 'jenkins', hostname: 'jenkins', memory: '4096', ip: '10.2.1.11', provision: 'provision_jenkins.sh'}]
    
host = [
    {box: host1_os.to_s, name: 'chefclient', hostname: 'chefclient', memory: '4096', ip: '10.2.1.20', provision: 'provision_lin.sh'}]

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.synced_folder '.', '/vagrant'
  	server.each do |server|
	config.vm.define server[:name] do |node|
	  node.vm.box = server[:box]
      node.vm.provision 'shell', path: server[:provision], privileged: true
	  node.vm.network :private_network, ip: "#{server[:ip]}"
	  node.vm.hostname = server[:hostname]
	  node.vm.provider :virtualbox do |vb|
		vb.name = server[:name]
        vb.memory = server[:memory]
	  end
	end
  end
  
  host.each do |host|
	config.vm.define host[:name] do |node|
	  node.vm.box = host[:box]
      node.vm.provision 'shell', path: host[:provision], privileged: true
	  node.vm.network :private_network, ip: "#{host[:ip]}"
	  node.vm.hostname = host[:hostname]
	  node.vm.provider :virtualbox do |vb|
		vb.name = host[:name]
        vb.memory = host[:memory]
	  end
	end
  end
end
