#!/bin/bash 

apt-get update -y
apt-get install nfs-kernel-server -y 

mkdir -p /mnt/nfs_share

chown -R nobody:nogroup /mnt/nfs_share/

chmod 777 /mnt/nfs_share/

echo "/mnt/nfs_share  192.168.1.0/24(rw,sync,no_subtree_check,no_root_squash)" > /etc/exports

exportfs -a
systemctl restart nfs-kernel-server




