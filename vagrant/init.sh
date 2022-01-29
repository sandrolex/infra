#!/bin/bash 

apt-get update -y
apt-get install docker.io jq -y
systemctl enable docker
systemctl start docker

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
apt-get install kubeadm kubelet kubectl -y
apt-mark hold kubeadm kubelet kubectl
swapoff -a
ufw disable

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

systemctl daemon-reload
systemctl restart docker


iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X

systemctl start kubelet

echo "192.168.1.200 mothership" >> /etc/hosts
echo "192.168.1.200 registry.viper.local" >> /etc/hosts
echo "192.168.1.192 master" >> /etc/hosts
echo "192.168.1.194 worker" >> /etc/hosts
echo "192.168.1.196 worker2" >> /etc/hosts
echo "192.168.1.198 worker3" >> /etc/hosts

cp /home/vagrant/viper.pem /usr/share/ca-certificates/viper.pem
echo "viper.pem" >> /etc/ca-certificates.conf
update-ca-certificates
