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

cat <<EOT > ../../ocp-config/install-config.yaml
apiVersion: v1beta3
baseDomain: nfvha233.nfvpe.redhat.com
compute:
- name: worker
  platform: {}
  replicas: 1
controlPlane:
  name: master
  platform: {}
  replicas: 1
metadata:
  creationTimestamp: null
  name: test
networking:
  clusterNetworks:
  - cidr: 10.128.0.0/14
    hostSubnetLength: 9
  machineCIDR: 192.168.126.0/24
  serviceCIDR: 172.30.0.0/16
  type: OpenShiftSDN
platform:
  openstack:
    cloud:            openstack
    externalNetwork:  public_network
    region:           regionOne
    computeFlavor:    medium.1
pullSecret: CHANGEME
sshKey: |
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDKtwTJ9u2QHNY9kiXw1RUECoEcnldprfJl13C6ITYLT4YvcZmr/sRHM2CUweM5wBQKrCzSGZQp1hS6vysCPtDg/yk+9L5tHKAPHuyDlZiA8yCvUQad5QzqaYh4Iz/INcC/MwsbEEd4JR8Sn6Lio3jRgy47MgHfgd2iWnMX7RQQzw== root@undercloud2.redhat.local
EOT

source ../shiftstackrc

FLOATER=`openstack floating ip list | grep -v ID | grep -v + | awk '{print $2}' | head -1`

while [ "$FLOATER" != "" ]
do
    openstack floating ip delete $FLOATER
    FLOATER=`openstack floating ip list | grep -v ID | grep -v + | awk '{print $2}' | head -1`
done

FLOATER=`openstack floating ip create public_network | grep floating_ip_address | cut -d '|' -f 3 | awk '{$1=$1};1'`

sudo sed -i '/api.test.nfvha233.nfvpe.redhat.com/c\'$FLOATER' api.test.nfvha233.nfvpe.redhat.com' /etc/hosts
sudo sed -i '/console-openshift-console.apps.nfvha233.nfvpe.redhat.com/c\'$FLOATER' console-openshift-console.apps.nfvha233.nfvpe.redhat.com' /etc/hosts

source ../overcloudrc

sed -i '/computeFlavor:/i\    \lbFloatingIP:     "'$FLOATER'"' ../../ocp-config/install-config.yaml

echo ">>> NOW YOU NEED TO MANUALLY SET THE PULL SECRET IN THE install-config.yaml FILE!"