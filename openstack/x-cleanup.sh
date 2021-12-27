#!/bin/bash

#TODO: delete VMs; delete floating IPs

microstack.openstack server list --format json | jq -r .[].ID | xargs microstack.openstack server delete

microstack.openstack floating ip list --format json | jq -r .[].ID | xargs microstack.openstack floating ip delete

