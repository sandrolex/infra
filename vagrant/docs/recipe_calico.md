# Recipe for creating a 3 nodes k8s with calico

1. Create the master node
```bash
cd run/master
vagrant up
```

2. Create worker nodes
```bash
cd run/worker2
vagrant up

cd run/worker3
vagrant up
```

3. Nodes should join the master
```bash
# on master
kubeadm token create --print-join-command

# on each node
vagrant ssh 
kubeadmn join..
```

4. Install calico cni
```bash
# on master
curl https://projectcalico.docs.tigera.io/manifests/calico.yaml -O
kubectl apply -f calico.yaml

# then
kubectl get pods --all-namespaces

# wait unti all pods are running
# coredns are the last ones

kubectl get nodes
# all nodes should be ready
```
