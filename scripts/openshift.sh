#!/bin/bash

source ../overcloudrc

openstack project create shiftstack
openstack project create devonly

openstack user create shiftstack_user --project shiftstack --password redhat
openstack user create devuser --project devonly --password redhat

openstack role add --user shiftstack_user --project shiftstack swiftoperator
openstack role add --user devuser --project devonly swiftoperator

openstack object store account set --property Temp-URL-Key=superkey

openstack quota set --secgroups 100 --secgroup-rules 1000 shiftstack
openstack quota set --secgroups 100 --secgroup-rules 1000 devonly

openstack network create --external --provider-network-type vlan --provider-physical-network datacentre --provider-segment 111 public_network
openstack subnet create external --network public_network --dhcp --allocation-pool start=10.19.111.150,end=10.19.111.250 --gateway 10.19.111.254 --subnet-range 10.19.111.0/24 --dns-nameserver 10.19.5.19 