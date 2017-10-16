openstack overcloud deploy \
--templates  \
-e ./templates/environments/network-isolation.yaml \
-e ./templates/environments/network-environment.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/docker.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/docker-ha.yaml \
-e ./templates/environments/docker_registry.yaml \
-e ./templates/ips-from-pool-all.yaml
