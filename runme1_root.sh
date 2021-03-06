#!/usr/bin/env bash
set -e

source /root/keystonerc_admin

glance image-create \
  --copy-from http://download.cirros-cloud.net/0.3.1/cirros-0.3.1-x86_64-disk.img \
  --is-public true \
  --container-format bare \
  --disk-format qcow2 \
  --name cirros

nova flavor-create m1.nano auto 64 1 1

keystone tenant-create --name=tenant1 --enabled=true
keystone user-create --name=user1 --pass=user1 --email=user1@example.com 
keystone user-role-add --user=user1 --role=_member_ --tenant=tenant1

## NOTE: physnetext --> must match what we used at answers.txt
neutron net-create ext --shared  --provider:network_type flat --provider:physical_network physnetext
neutron net-update ext --router:external=True

neutron subnet-create --allocation-pool start=192.168.111.21,end=192.168.111.99 --gateway=192.168.111.254 \
--disable-dhcp --name subext ext 192.168.111.0/24

