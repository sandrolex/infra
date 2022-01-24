# Recipe for creating a 3 nodes k8s with flannel

1. Create the master node
```bash
cd run/master
vagrant up
```

2. Terminate master config
```bash
vagrant ssh 
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

3. Create worker nodes
```bash
cd run/worker2
vagrant up

cd run/worker3
vagrant up
```

4. Nodes should join the master
```bash
# on master
kubeadm token create --print-join-command

# on each node
vagrant ssh 
kubeadmn join..
```

5. Install flannel cni
```bash
# on master
wget  https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
vim kube-flannel.yml
# add 
# - --iface=eth1 
# on the containers definition
kubectl create -f kube-flannel.yml

# then
kubectl get pods --all-namespaces

# wait unti all pods are running
# coredns are the last ones

kubectl get nodes
# all nodes should be ready
```
