#!/bin/bash

#
# ASSUMPTIONS:
#
# The overcloud must already be deployed and running!
#
# 1. This is being run from a sub-directory
# 2. Parent directory has a valid overcloudrc
# 3. Parent directory's parent directory has a sub-directory called "ocp-images"
# 4. "ocp-images" contains an RHCOS qcow2 image with a filename format like so:
#    rhcos-<version>-openstack.qcow2
# 5. Parent directory's parent directory has a sub-directory called "ocp-config"
#
# Example directory structure:
#
# /home/stack/ha-director-install (overcloudrc's location)
# /home/stack/ha-director-install/scripts (this script's location)
# /home/stack/ocp-config
# /home/stack/ocp-images
#

source ../overcloudrc

AUTH_URL=`openstack endpoint list | grep keystone | grep public | cut -d '|' -f 8 | awk '{$1=$1};1'`

cat <<EOT > ../../ocp-config/clouds.yaml
clouds:
  openstack:
    auth:
      auth_url: ${AUTH_URL}/v3
      project_name: shiftstack
      username: shiftstack_user
      password: redhat
      user_domain_name: Default
      project_domain_name: Default
  dev-evn:
    region_name: RegionOne
    auth:
      username: 'devuser'
      password: redhat
      project_name: 'devonly'
      auth_url: '${AUTH_URL}/v3'
EOT

export OS_CLIENT_CONFIG_FILE=/home/stack/ocp-config/clouds.yaml

openstack flavor create --ram 512 --disk 1 --vcpus 1 --public cirros.1
openstack flavor create --ram 1024 --disk 1 --vcpus 1 --public small.1
openstack flavor create --ram 4096 --disk 40 --vcpus 2 --public medium.1
openstack flavor create --ram 8192 --disk 60 --vcpus 4 --public large.1

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
openstack subnet create external --network public_network --dhcp --allocation-pool start=10.19.111.150,end=10.19.111.250 --gateway 10.19.111.254 --subnet-range 10.19.111.0/24 --dns-nameserver 10.11.5.19 

RHCOS_VERSION=`ls -ht ../../ocp-images/ | grep rhcos | awk {'print $1'} | cut -d '-' -f 2`

openstack image create --container-format=bare --disk-format=qcow2 --public --file ../../ocp-images/rhcos-${RHCOS_VERSION}-openstack.qcow2 rhcos

cp ../overcloudrc ../shiftstackrc
sed -i 's/OS_USERNAME=admin/OS_USERNAME=shiftstack_user/' ../shiftstackrc 
sed -i '/OS_PASSWORD/c\export OS_PASSWORD=redhat' ../shiftstackrc
sed -i 's/OS_PROJECT_NAME=admin/OS_PROJECT_NAME=shiftstack/' ../shiftstackrc

./openshift_regen