#!/bin/sh

tac /var/log/nova/nova-conductor.log | grep 'The hints';
if [ $? == 0 ]; then
   echo "

for node in $(ironic node-list | grep -v UUID| awk '{print $2}'); 
    do 
      swift -U service:ironic -K $SWIFT_PASSWORD download ironic-inspector inspector_data-$node; 
      if [ -e inspector_data-$node ]; then
        mv inspector_data-$node swift-data;
      fi
  done
