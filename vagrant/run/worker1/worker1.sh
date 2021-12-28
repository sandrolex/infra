#!/bin/bash

echo "prepare kubelet"
sed -i '5 i Environment="KUBELET_EXTRA_ARGS=--node-ip=192.168.1.194"' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl daemon-reload
systemctl restart kubelet
sleep 10