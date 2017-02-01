#!/bin/sh
openstack network create default
openstack subnet create default --network default --gateway 172.20.1.1 --subnet-range 172.20.0.0/16
openstack network create --external --provider-network-type vlan --provider-physical-network datacentre --provider-segment 100 external
openstack subnet create nova --network external --dhcp --allocation-pool start=10.19.108.150,end=10.19.108.250 --gateway 10.19.108.254 --subnet-range 10.19.108.0/24 
openstack subnet create external --network external --dhcp --allocation-pool start=10.19.108.150,end=10.19.108.250 --gateway 10.19.108.254 --subnet-range 10.19.108.0/24 

openstack router create external
openstack router add subnet external default
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

openstack image create --disk-format qcow2 --public --location http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1503.qcow2 centos7.2
openstack image create --disk-format qcow2 --public --location https://download.fedoraproject.org/pub/fedora/linux/releases/25/CloudImages/x86_64/images/Fedora-Cloud-Base-25-1.3.x86_64.qcow2 fedora-25
openstack image create --disk-format qcow2 --public --location http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1503.qcow2c centos-7