Vagrant.configure(2) do |config|
  config.vm.box = "larryli/wily64"
  config.vm.network "forwarded_port", guest: 22, host: 2231
  config.vm.network "private_network", ip: "10.10.10.22"
  config.vm.synced_folder(".", nil, :disabled => true, :id => "vagrant-root")
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "4096"
    file_to_disk = File.realpath('.') + '/sdb.vdi'
    vb.customize [
        'createhd',
        '--filename', file_to_disk,
        '--format', 'VDI',
        '--size', 10 * 1024
    ]
    vb.customize [
        'storageattach', :id,
        '--storagectl', 'SATAController',
        '--port', 1, '--device', 0,
        '--type', 'hdd', '--medium',
        file_to_disk
    ]
  end
  config.vm.provision "shell", path: "provision-vagrant.sh"
end
