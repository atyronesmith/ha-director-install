#!/bin/sh
neutron net-create --provider:network_type vlan --provider:physical_network physnet_sriov1 --provider:segmentation_id 2000 sriov1
net_id=$(neutron net-list | grep sriov1 | awk '{print $2}')
neutron subnet-create $net_id --allocation_pool start=172.21.0.2,end=172.21.1.0 --name sriov1-sub 172.21.0.0/16
sub_id=$(neutron subnet-list | grep sriov1-sub | awk '{print $2}')
neutron port-create --name sriov1-port --fixed-ip subnet_id=$sub_id,ip_address=172.21.0.10 --vnic-type direct $net_id

neutron net-create --provider:network_type vlan --provider:physical_network physnet_sriov2 --provider:segmentation_id 2100 sriov2
net_id=$(neutron net-list | grep sriov2 | awk '{print $2}')
neutron subnet-create $net_id --allocation_pool start=172.22.0.2,end=172.22.1.0 --name sriov2-sub 172.22.0.0/16
sub_id=$(neutron subnet-list | grep sriov2-sub | awk '{print $2}')
neutron port-create --name sriov2-port --fixed-ip subnet_id=$sub_id,ip_address=172.22.0.10 --vnic-type direct $net_id


