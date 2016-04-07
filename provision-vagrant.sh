#!/usr/bin/env bash
apt-get install -y python-minimal zfsutils-linux
zpool create -f netstore /dev/sdb
zfs set compression=lz4 netstore
