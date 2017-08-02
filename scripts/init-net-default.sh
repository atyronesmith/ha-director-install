#!/bin/sh
openstack network create default
openstack subnet create default --network default --gateway 172.20.1.1 --subnet-range 172.20.0.0/16
openstack network create --external --provider-network-type vlan --provider-physical-network datacentre --provider-segment 111 external
openstack subnet create external --network external --dhcp --allocation-pool start=10.19.111.150,end=10.19.111.250 --gateway 10.19.111.254 --subnet-range 10.19.111.0/24 --dns-nameserver 10.19.5.19 

openstack router create external
openstack router add subnet external default
neutron router-gateway-set external external 
