#!/bin/sh

# 1. run on controller(s) in overcloud!
# 2. find IPs by doing: swift-ring-builder object.ring.gz 
# 3. find proper IPs via "ip a"
# 4. run this script, passing bad IPs

first=$1
second=$2
third=$3

if [[ -z $third ]] ; then
  third="" ;
fi

for i in $first $second $third; do sudo swift-ring-builder /etc/swift/account.builder remove $i; sudo swift-ring-builder /etc/swift/object.builder remove $i; sudo swift-ring-builder /etc/swift/container.builder remove $i; done

sudo swift-ring-builder /etc/swift/object.builder rebalance
sudo swift-ring-builder /etc/swift/account.builder rebalance
sudo swift-ring-builder /etc/swift/container.builder rebalance

for i in $(systemctl | grep swift | awk {'print $1'}); do systemctl restart $i; done
