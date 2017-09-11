openstack overcloud deploy \
--templates --stack overcloud \
-e ./templates/environments/network-isolation.yaml \
-e ./templates/environments/network-environment.yaml \
-e ./templates/environments/neutron-sriov.yaml \
-e ./templates/ips-from-pool-all.yaml
