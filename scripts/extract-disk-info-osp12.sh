#!/bin/sh
root_disk=$1
swift_data_dir="swift-data"

echo "Searching for..." ${root_disk}

for node in $(ironic node-list | grep available | awk '!/UUID/ {print $2}'); 
  do 
    if [ -e ${swift_data_dir}/data_$node ]; then
       JQ_CMD=".inventory.disks[] | select(.name | . and contains(\"${root_disk}\")) | .wwn"
       WWN=$(cat ${swift_data_dir}/data_$node | jq "${JQ_CMD}")
       # the quotes on the key, wwn are important!
       echo "openstack baremetal node set --property root_device='{\"wwn\": "${WWN}"}' ${node}"
    fi
  done
