#!/bin/sh
openstack network create default
openstack subnet create default --network default --gateway 172.20.1.1 --subnet-range 172.20.0.0/16
openstack network create --external --provider-network-type vlan --provider-physical-network datacentre --provider-segment 111 external
openstack subnet create nova --network external --dhcp --allocation-pool start=10.19.111.150,end=10.19.111.250 --gateway 10.19.111.254 --subnet-range 10.19.111.0/24 
openstack subnet create external --network external --dhcp --allocation-pool start=10.19.111.150,end=10.19.111.250 --gateway 10.19.111.254 --subnet-range 10.19.111.0/24 

neutron net-create dpdk0 --provider:network_type vlan --provider:segmentation_id 2001 --provider:physical_network dpdk  #(name given in Neutron bridgeMappings)
neutron subnet-create --name dpdk0 --allocation-pool start=20.35.185.49,end=20.35.185.61 --dns-nameserver 8.8.8.8 --gateway 20.35.185.62 dpdk0 20.35.185.48/28
dpdk0_net=$(neutron net-list | awk ' /dpdk0/ {print $2;}')

openstack router create external
openstack router add subnet external default
openstack router add subnet external dpdk0
neutron router-gateway-set external external 

openstack floating ip create external
openstack floating ip create external
openstack floating ip create external
openstack floating ip create external
openstack floating ip create external
openstack floating ip create external
openstack floating ip create external

openstack keypair create --public-key /home/stack/.ssh/id_rsa.pub undercloud-stack

openstack security group create all-access
openstack security group rule create --ingress --protocol icmp --src-ip 0.0.0.0/0 all-access
openstack security group rule create --ingress --protocol tcp --src-ip 0.0.0.0/0 all-access
openstack security group rule create --ingress --protocol udp --src-ip 0.0.0.0/0 all-access


openstack flavor create --ram 512 --disk 1 --vcpus 1 --public cirros.1
openstack flavor create --ram 1024 --disk 1 --vcpus 1 --public small.1
openstack flavor create --ram 2048 --disk 10 --vcpus 2 --public medium.1
openstack flavor create --ram 4096 --disk 20 --vcpus 4 --public large.1
