#!/bin/bash 

apt-get update -y
apt-get install nfs-kernel-server -y 

mkdir -p /mnt/nfs_share
mkdir -p /mnt/kube_logs
mkdir -p /mnt/uploads

chown -R nobody:nogroup /mnt/nfs_share/
chown -R nobody:nogroup /mnt/kube_logs/
chown -R nobody:nogroup /mnt/uploads/

chmod 777 /mnt/nfs_share/
chmod 777 /mnt/kube_logs/
chmod 777 /mnt/uploads/

echo "/mnt/nfs_share  192.168.1.0/24(rw,sync,no_subtree_check,no_root_squash)" >> /etc/exports
echo "/mnt/kube_logs  192.168.1.0/24(rw,sync,no_subtree_check,no_root_squash)" >> /etc/exports
echo "/mnt/uploads    192.168.1.0/24(rw,sync,no_subtree_check,no_root_squash)" >> /etc/exports

exportfs -a
systemctl restart nfs-kernel-server




