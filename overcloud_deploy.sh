openstack overcloud deploy \
--templates  \
-r ./templates/roles_data.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/host-config-and-reboot.yaml \
-e ./templates/environments/network-isolation.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/neutron-opendaylight-sriov.yaml \
-e ./templates/environments/neutron-l2gw-opendaylight.yaml \
-e ./templates/environments/network-environment.yaml \
-e ./templates/environments/docker_registry.yaml \
-e ./templates/ips-from-pool-all.yaml
