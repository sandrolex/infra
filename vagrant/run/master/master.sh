#!/bin/bash

echo "prepare kubelet"
sed -i '5 i Environment="KUBELET_EXTRA_ARGS=--node-ip=192.168.1.192"' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl daemon-reload
systemctl restart kubelet
sleep 10

echo "kubeadm"
#kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.1.192 --skip-phases=addon/kube-proxy
kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.1.192 

mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown 1000:1000 /home/vagrant/.kube/config

# install helm3
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# install cilium
curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz{,.sha256sum}
#sha256sum --check cilium-linux-amd64.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
#rm cilium-linux-amd64.tar.gz{,.sha256sum}



