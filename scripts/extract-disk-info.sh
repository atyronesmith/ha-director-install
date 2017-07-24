#!/bin/sh
root_disk=$1
echo "Searching for..." ${root_disk}

for node in $(ironic node-list | awk '!/UUID/ {print $2}'); 
  do 
    if [ -e inspector_data-$node ]; then
#      echo "NODE: $node" ; cat inspector_data-$node | jq '.inventory.disks' ; echo "-----" ; 
       JQ_CMD=".inventory.disks[] | select(.name | . and contains(\"${root_disk}\")) | .wwn"
#       echo "${JQ_CMD}"
       WWN=$(cat inspector_data-$node | jq "${JQ_CMD}")
       echo "openstack baremetal node set --property root_device='{"wwn": "${WWN}"}' ${node}"
    fi
  done
