Simple (cheap?) Linux NAS
=========================

I use this project to manage my home NAS, which is utilized for a number
of Time Machine and other backups as well as a single filesystem for occasional
use.

The NAS hardware can be any reliable box which supports Ubuntu 15.10 Server
and ZFS and has at least one available disk.  The box will be dedicated to
NAS and reinstalled from scratch as part of setup.  A 64-bit CPU and at least
4GB of RAM is required, as those are the recommendations for ZFS.

The code in this project remotely manages the set of users and exported
filesystems on the NAS.  It also supports a Vagrant box NAS for testing
end-user configuration and modifications to the project.

My current NAS hardware is an older Thinkpad with 4GB of memory, a
Core 2 Duo CPU, and a 4TB external drive unit attached via USB 2.0.  The limiting
performance factor for most client machines in my environment is the wireless
network, as only a few machines (including the NAS) have Ethernet.  When
seeding two initial Time Machine backups simultaneously, one over Ethernet and one over
wireless, disk I/O on the NAS approached the limitation of USB 2.0, reaching
15MB/second occasionally.  At the same time, the two Netatalk processes
handling the two clients reached 20% CPU each.  But this is a rare activity.
Thus, I expect that a NAS hardware upgrade would be appropriate for performance
only if I had client machines on Ethernet using filesystems on the NAS for
normal operation.

Limitations
-----------

Currently you can configure filesystems to be exported as Time Machine volumes
or NFS shares.  CIFS is an obvious alternative, but it is not currently
supported.

Creation of the ZFS pool, and thus the choice of RAID and other important
characteristics, is not automated or even well-documented here.  (That may
be a feature.)

Todos
-----

Here are my priorities for upcoming changes:

1. Automatic install of Ubuntu updates, with reboot when appropriate
2. ZFS snapshot utility
   A user should be able to run a command to remotely create a snapshot of
   their remote filesystem.
3. CIFS shares
4. Remote backup of the NAS
5. Scheduled ZFS snapshots, with schedule tied to a specific filesystem

Setting up a real machine for your NAS
--------------------------------------

Choose a machine and install Ubuntu 15.10 Server on it.  Leave at least one
physical, internal or external disk free.  You won't mix the OS and the 
shared storage on the same disk.

Connect it to the network with a permanently-assigned IP address.  One way:

1. Connect your NAS to Ethernet network.
2. Use ifconfig on your NAS to display the mac address.
3. Find the current DHCP-assigned IP address for that mac address in the DHCP
   server management console and configure the server to permanently assign
   that IP to that device.

Give password-less `sudo` access to the initial user created during Ubuntu install.

Install some initial software which will enable ZFS and remote operations via Ansible::

    apt-get install python-minimal zfsutils-linux

Create a ZFS pool called `netstore` on the dedicated disks used for shared
storage.  This is not automated, because it should be tailored for your exact
disk configuration.

A sample ZFS pool setup is in the `provision-vagrant.sh` script.  It uses a
single device, `/dev/sdb` for shared storage; compression is enabled.  With
multiple devices you can enable different types of RAID.

Defining resources on your NAS
------------------------------

After initial setup, the NAS is managed by Ansible, with configuration stored
in files `hosts` and `vars.yml`.

`hosts` stores the IP address or hostname for the NAS as well as the name of
the user id on the NAS with `sudo` access which will be used for Ansible
operations.  See `hosts.sample` for an example.

`vars.yml` maintains the set of users which should be defined on the NAS and
the list of filesystems.  Currently you can configure filesystems to be
exported as Time Machine volumes or NFS shares.  See `vars.yml.sample` for
an example.
 
Deploying your configuration to the NAS
---------------------------------------

Run `./deploy.sh production` to configure or reconfigure your NAS.

This uses Ansible 2.0.  I recommend creating a virtualenv using the supplied
requirements.txt file.  (Per Ansible requirements, this virtualenv must use 
Python 2.7.)  Activate the virtualenv before running `deploy.sh`.

Testing your configuration with Vagrant
---------------------------------------

Create separate configuration files `vagrant_hosts` and `vagrant_vars.yml`
for the Vagrant box configuration.  Vagrant and Virtualbox must be installed.
Check the `config.vm.network` lines in `Vagrantfile` to see if those settings
will collide with any existing Vagrant boxes you are using; fix as necessary.

Run `vagrant up` then `./deploy.sh vagrant` to create and configure, and then
`vagrant halt` to stop and `vagrant destroy` to delete the VM.
