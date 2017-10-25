#!/bin/sh

openstack network create default
openstack subnet create default --network default --gateway 172.20.1.1 --subnet-range 172.20.0.0/16
openstack network create --external --provider-network-type vlan --provider-physical-network datacentre --provider-segment 111 external
openstack subnet create external --network external --dhcp --allocation-pool start=10.19.111.150,end=10.19.111.250 --gateway 10.19.111.254 --subnet-range 10.19.111.0/24 --dns-nameserver 10.19.5.19 

neutron net-create dpdk0 --provider:network_type vlan --provider:segmentation_id 2200 --provider:physical_network dpdk  #(name given in Neutron bridgeMappings)
neutron subnet-create --name dpdk0 --allocation-pool start=20.35.185.49,end=20.35.185.61 --dns-nameserver 8.8.8.8 --gateway 20.35.185.62 dpdk0 20.35.185.48/28
dpdk0_net=$(neutron net-list | awk ' /dpdk0/ {print $2;}')

openstack router create external
openstack router add subnet external default
openstack router add subnet external dpdk0
neutron router-gateway-set external external

openstack floating ip create external
openstack floating ip create external
openstack floating ip create external

openstack keypair create --public-key /home/stack/.ssh/id_rsa.pub undercloud-stack

openstack flavor create --ram 512 --disk 1 --vcpus 1 --property hw:mem_page_size=large --public cirros.1
openstack flavor create --ram 1024 --disk 1 --vcpus 1 --property hw:mem_page_size=large --public small.1
openstack flavor create --ram 2048 --disk 10 --vcpus 2 --property hw:mem_page_size=large --public medium.1
openstack flavor create --ram 4096 --disk 20 --vcpus 4 --property hw:mem_page_size=large --public large.1

###
### NOTE: Use this flavor for instances that have DPDK and SRIOV ports
###
openstack flavor create --ram 2048 --disk 10 --vcpus 4 --property hw:mem_page_size=large --property hw:numa_cpus.0=0,1 --property hw:numa_cpus.1=2,3 --property hw:numa_mem.0=1024 --property hw:numa_mem.1=1024 --property hw:numa_nodes=2 --public medium.2

openstack security group create all-access
openstack security group rule create --ingress --protocol icmp --src-ip 0.0.0.0/0 all-access
openstack security group rule create --ingress --protocol tcp --src-ip 0.0.0.0/0 all-access
openstack security group rule create --ingress --protocol udp --src-ip 0.0.0.0/0 all-access

neutron net-create --provider:network_type vlan --provider:physical_network physnet_sriov1 --provider:segmentation_id 2000 sriov1
net_id=$(neutron net-list | grep sriov1 | awk '{print $2}')
neutron subnet-create $net_id --allocation_pool start=172.21.0.2,end=172.21.1.0 --name sriov1 172.21.0.0/16
sub_id=$(neutron subnet-list | grep sriov1 | awk '{print $2}')
neutron port-create --name sriov1 --fixed-ip subnet_id=$sub_id,ip_address=172.21.0.10 --vnic-type direct $net_id
neutron port-create --name sriov2 --fixed-ip subnet_id=$sub_id,ip_address=172.21.0.11 --vnic-type direct $net_id

neutron net-create --provider:network_type vlan --provider:physical_network physnet_sriov2 --provider:segmentation_id 2100 sriov2
net_id=$(neutron net-list | grep sriov2 | awk '{print $2}')
neutron subnet-create $net_id --allocation_pool start=172.22.0.2,end=172.22.1.0 --name sriov2 172.22.0.0/16
sub_id=$(neutron subnet-list | grep sriov2 | awk '{print $2}')
neutron port-create --name sriov3 --fixed-ip subnet_id=$sub_id,ip_address=172.22.0.20 --vnic-type direct $net_id
neutron port-create --name sriov4 --fixed-ip subnet_id=$sub_id,ip_address=172.22.0.21 --vnic-type direct $net_id
