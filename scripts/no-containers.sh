THT_ROOT=/usr/share/openstack-tripleo-heat-templates/
cd $THT_ROOT/environments
> docker.yaml
> docker-ha.yaml
find . -exec sed -i -e "s|docker/services/collectd.yaml|puppet/services/metrics/collectd.yaml|g" {} \;
find . -exec sed -e "s|docker/services/sensu-client.yaml|puppet/services/monitoring/sensu-client.yaml|g" -i {} \;
find . -exec sed -e "s|docker/services|puppet/services|g" -i {} \;
