#!/bin/bash

openstack network create default
openstack subnet create default --network default --gateway 172.20.1.1 --subnet-range 172.20.0.0/16
openstack network create --external --provider-network-type vlan --provider-physical-network datacentre --provider-segment 111 external
openstack subnet create external --network external --dhcp --allocation-pool start=10.19.111.220,end=10.19.111.230 --gateway 10.19.111.254 --subnet-range 10.19.111.0/24 --dns-nameserver 10.11.5.19

openstack router create external
openstack router add subnet external default
neutron router-gateway-set external external

openstack floating ip create external
openstack floating ip create external
openstack floating ip create external

openstack flavor create --ram 512 --disk 1 --vcpus 1 --public cirros.1
openstack flavor create --ram 1024 --disk 1 --vcpus 1 --public small.1
openstack flavor create --ram 2048 --disk 10 --vcpus 2 --public medium.1
openstack flavor create --ram 4096 --disk 20 --vcpus 4 --public large.1

openstack security group create all-access
openstack security group rule create --ingress --protocol icmp --src-ip 0.0.0.0/0 all-access
openstack security group rule create --ingress --protocol tcp --src-ip 0.0.0.0/0 all-access
openstack security group rule create --ingress --protocol udp --src-ip 0.0.0.0/0 all-access

openstack server create --flavor large.1 --image centos-7 --nic net-id=a4bb8f28-455a-4f22-a90d-88deb6fa71e5 --security-group all-access blah
