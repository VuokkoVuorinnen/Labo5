# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    domain = '.chem.net'

    # DNS Server
    config.vm.define :helium do |server|
        server.vm.box = "centos64"
        server.vm.box_url = "http://packages.vstone.eu/vagrant-boxes/centos-6.x-64bit-latest.box"

        server.vm.hostname = "helium#{domain}"
        server.vm.network :private_network, ip: '192.168.64.2'

        # By sharing the project folder as /etc/puppet, a lot of stuff "just
        # works": Hiera, modules, files, etc.
        server.vm.synced_folder ".", "/etc/puppet"

        server.vm.provider :virtualbox do |vb|
            vb.gui = false
            vb.name = 'helium'
            vb.customize ["modifyvm", :id, '--cpus', 1 ]
            vb.customize ["modifyvm", :id, '--memory', 512 ]
            vb.customize ["modifyvm", :id, '--hostonlyadapter2', 'vboxnet2']
        end

        server.vm.provision :puppet do |puppet|
            puppet.manifest_file = "site.pp"
        end
    end

    # DHCP Server
    config.vm.define :beryllium do |server|
        server.vm.box = "centos64"
        server.vm.box_url = "http://packages.vstone.eu/vagrant-boxes/centos-6.x-64bit-latest.box"

        server.vm.hostname = "beryllium#{domain}"
        server.vm.network :private_network, ip: '192.168.64.4'
        server.vm.synced_folder ".", "/etc/puppet"

        server.vm.provider :virtualbox do |vb|
            vb.gui = false
            vb.name = 'beryllium'
            vb.customize ["modifyvm", :id, '--cpus', 1 ]
            vb.customize ["modifyvm", :id, '--memory', 512 ]
            vb.customize ["modifyvm", :id, '--hostonlyadapter2', 'vboxnet2']
        end

        server.vm.provision :puppet do |puppet|
            puppet.manifest_file = "site.pp"
        end
    end

    # Mail Server
    config.vm.define :carbon do |server|
        server.vm.box = "centos64"
        server.vm.box_url = "http://packages.vstone.eu/vagrant-boxes/centos-6.x-64bit-latest.box"

        server.vm.hostname = "carbon#{domain}"
        server.vm.network :private_network, ip: '192.168.64.6'

        # By sharing the project folder as /etc/puppet, a lot of stuff "just
        # works": Hiera, modules, files, etc.
        server.vm.synced_folder ".", "/etc/puppet"

        server.vm.provider :virtualbox do |vb|
            vb.gui = false
            vb.name = 'carbon'
            vb.customize ["modifyvm", :id, '--cpus', 1 ]
            vb.customize ["modifyvm", :id, '--memory', 512 ]
            vb.customize ["modifyvm", :id, '--hostonlyadapter2', 'vboxnet2']
        end

        server.vm.provision :puppet do |puppet|
            puppet.manifest_file = "site.pp"
        end
    end

    # Test box for DHCP
    config.vm.define :neon do |client|
        client.vm.box = 'centos64'
        client.vm.hostname = "neon#{domain}"
        client.vm.network :private_network, type: :dhcp
        client.vm.synced_folder ".", "/etc/puppet"

        client.vm.provider :virtualbox do |vb|
            vb.gui = false
            vb.name = 'neon'
            vb.customize ["modifyvm", :id, '--cpus', 1 ]
            vb.customize ["modifyvm", :id, '--memory', 512 ]
            # Mac-address from common.yaml
            vb.customize ["modifyvm", :id, '--macaddress2', '080027708DB3' ]
            vb.customize ["modifyvm", :id, '--hostonlyadapter2', 'vboxnet2']
        end

        client.vm.provision :puppet do |puppet|
            puppet.manifest_file = "site.pp"
        end
    end
end
