#!/bin/bash

echo "prepare kubelet"
sed -i '5 i Environment="KUBELET_EXTRA_ARGS=--node-ip=xxx"' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl daemon-reload
systemctl restart kubelet
sleep 10

echo "kubeadm"
kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.1.192



