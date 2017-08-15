openstack overcloud deploy \
--templates  \
-e ./templates/environments/network-isolation.yaml \
-e ./templates/environments/network-environment.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/neutron-opendaylight.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/neutron-sriov.yaml \
-e ./templates/ips-from-pool-all.yaml
