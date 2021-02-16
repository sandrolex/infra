#!/bin/bash

wget 10.20.20.1:8000/calico.yaml
wget 10.20.20.1:8000/dep-test.yaml

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f calico.yaml

# join nodes


