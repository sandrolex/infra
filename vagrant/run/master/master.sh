#!/bin/bash


sed -i 's/xxx/192.168.1.192/g' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl daemon-reload
systemctl restart kubelet

kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.1.192



