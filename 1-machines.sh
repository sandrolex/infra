#!/bin/bash
id=$(microstack.openstack server create --image Bionic --flavor m1.large --security-group Open --nic net-id=test --key-name microstack --user-data init.file w --format json | jq -r .id)
echo "created machine $id"

ip=$(microstack.openstack floating ip create -f value -c floating_ip_address 'external')
echo "created ip $ip"

microstack.openstack server add floating ip $id $ip
echo "floating ip created" 

#microstack launch --name master --flavor m1.large Bionic

#microstack launch --name worker1 --flavor m1.medium Bionic
#microstack launch --name worker2 --flavor m1.medium Bionic

