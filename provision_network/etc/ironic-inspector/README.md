If using a vlan in undercloud, target the vlan interface instead of br-ctlplane

Restart ironic services afterwords:
for i in $(systemctl | grep ironic | awk {'print $1'}); do systemctl restart $i; done
