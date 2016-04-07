Simple (cheap?) Linux NAS
=========================

I use this project for my home NAS currently after initially considering
purchasing of an appliance-like solution.  The NAS can be any reliable box
which supports Ubuntu 15.10 and ZFS and has at least one available disk. 
(64-bit is essentially required for ZFS; I use an older Thinkpad with
Core 2 Duo and an external drive unit.)

The code in this project remotely manages the set of users and exported
filesystems on the NAS.  It also supports a Vagrant box version for testing
your configuration and modifications to the project.

Limitations
-----------

Currently you can configure filesystems to be exported as Time Machine volumes
or NFS shares.  CIFS is an obvious alternative, but it is not currently
supported.

Creation of the ZFS pool, and thus the choice of RAID and other important
characteristics, is not automated or even well-documented here. 

Setting up a real machine for your NAS
--------------------------------------

Choose a machine and install Ubuntu 15.10 on it.  Leave at least one physical
disk free.  You won't mix the OS and the shared storage on the same disk.

Connect it to the network with a permanently-assigned IP address.  One way:

1. Connect your NAS to Ethernet network.
2. Use ifconfig on your NAS to display the mac address.
3. Find the current DHCP-assigned IP address for that mac address in the DHCP
   server management console and configure the server to permanently assign
   that IP to that device.

Give password-less ``sudo`` access to the initial user created during Ubuntu install.

Install some initial software which will enable ZFS and remote operations via Ansible::

    apt-get install python-minimal zfsutils-linux

Create a ZFS pool called ``netstore`` on the dedicated disks used for shared
storage.  This is not automated, because it should be tailored for your exact
disk configuration.

A sample ZFS pool setup is in the ``provision-vagrant.sh`` script.  It uses a
single device, ``/dev/sdb`` for shared storage; compression is enabled.  With
multiple devices you can enable different types of RAID.

Defining resources on your NAS
------------------------------

After initial setup, the NAS is managed by Ansible, with configuration stored
in files ``hosts`` and ``vars.yml``.

``hosts`` stores the IP address or hostname for the NAS as well as the name of
the user id on the NAS with ``sudo`` access which will be used for Ansible
operations.  See ``hosts.sample`` for an example.

``vars.yml`` maintains the set of users which should be defined on the NAS and
the list of filesystems.  Currently you can configure filesystems to be
exported as Time Machine volumes or NFS shares.  See ``vars.yml.sample`` for
an example.
 
Deploying your configuration to the NAS
---------------------------------------

Run ``./deploy.sh production`` to configure or reconfigure your NAS.

This uses Ansible 2.0.  I recommend creating a virtualenv using the supplied
requirements.txt file.  (Per Ansible requirements, this virtualenv must use 
Python 2.7.)  Activate the virtualenv before running ``deploy.sh``.

Testing your configuration with Vagrant
---------------------------------------

Create separate configuration files ``vagrant_hosts`` and ``vagrant_vars.yml``
for the Vagrant box configuration.

Run ``vagrant up`` then ``./deploy.sh vagrant`` to create and configure.
