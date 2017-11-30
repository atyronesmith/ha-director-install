# this deploys without L2GW, and just does SRIOV+ODL

openstack overcloud deploy \
--templates  \
-e ./templates/environments/network-isolation.yaml \
-e ./templates/environments/network-environment.yaml \
-e ./templates/environments/neutron-sriov.yaml \
-e ./templates/environments/neutron-opendaylight-l3.yaml \
-e ./templates/ips-from-pool-all.yaml
