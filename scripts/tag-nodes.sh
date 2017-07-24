#!/bin/sh
for i in $(ironic node-list | grep -v UUID | grep control | awk '{print $2}'); 
  do 
    openstack baremetal node set --property capabilities='profile:control,cpu_hugepages:true,cpu_txt:true,cpu_vt:true,boot_option:local,cpu_aes:true,cpu_hugepages_1g:true,boot_mode:uefi' $i; 
  done

for i in $(ironic node-list | grep -v UUID | grep compute | awk '{print $2}'); 
  do 
    openstack baremetal node set --property capabilities='profile:compute,cpu_hugepages:true,cpu_txt:true,cpu_vt:true,boot_option:local,cpu_aes:true,cpu_hugepages_1g:true,boot_mode:uefi' $i; 
  done

for i in $(ironic node-list | grep -v UUID | grep ceph | awk '{print $2}'); 
  do 
    openstack baremetal node set --property capabilities='profile:ceph-storage,cpu_hugepages:true,cpu_txt:true,cpu_vt:true,boot_option:local,cpu_aes:true,cpu_hugepages_1g:true,boot_mode:uefi' $i; 
  done
