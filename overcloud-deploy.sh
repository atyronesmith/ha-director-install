openstack overcloud deploy \
--templates  \
-r ./templates/roles_data.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/neutron-ovs-dpdk.yaml \
-e ./templates/environments/network-isolation.yaml \
-e ./templates/environments/network-environment.yaml \
-e ./templates/environments/neutron-sriov.yaml \
-e ./templates/ips-from-pool-all.yaml
