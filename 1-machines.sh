#!/bin/bash

create_vm() {
    echo "creating $1"
    id=$(microstack.openstack server create --image Bionic --flavor m1.large --security-group aa715ebf-6e06-4540-b6c5-7bdb50571e1b --security-group Open --nic net-id=test --key-name microstack --user-data 2-prepare-vm.sh $1 --format json | jq -r .id)
    echo "created machine $id"

    ip=$(microstack.openstack floating ip create -f value -c floating_ip_address 'external')
    echo "created ip $ip"

    microstack.openstack server add floating ip $id $ip
    echo "floating ip created" 
}

create_vm master
create_vm worker1


