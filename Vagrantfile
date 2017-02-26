Vagrant.configure(2) do |config|
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.network "forwarded_port", guest: 22, host: 2231
  config.vm.network "private_network", ip: "10.10.10.22"
  config.vm.synced_folder(".", nil, :disabled => true, :id => "vagrant-root")
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "4096"
    nas_sdb_disk_file = File.realpath('.') + '/sdb.vdi'
    unless File.exist?(nas_sdb_disk_file)
        vb.customize [
            'createhd',
            '--filename', nas_sdb_disk_file,
            '--format', 'VDI',
            '--size', 10 * 1024
        ]
    end
    vb.customize [
        'storageattach', :id,
        # To list storage controller names for a VM, run
        #  $ vboxmanage showvminfo <uuid>
        '--storagectl', 'SATA Controller',
        '--port', 1, '--device', 0,
        '--type', 'hdd', '--medium',
        nas_sdb_disk_file
    ]
  end
  config.vm.provision "shell", path: "provision-vagrant.sh"
end
