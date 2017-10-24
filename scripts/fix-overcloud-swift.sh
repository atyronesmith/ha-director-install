#!/bin/sh

# 1. run on controller(s) in overcloud!
# 2. find proper IPs via "ip a"
# 3. run this script, passing proper IPs

first=$1
second=$2
third=$3

if [[ -z $second ]] ; then
  second="" ;
fi

if [[ -z $third ]] ; then
  third="" ;
fi

for i in $(swift-ring-builder /etc/swift/account.builder | grep 6002 | awk '{print $4}' | cut -d ":" -f 1); do
    if [ "$i" != "$first" ] && [ "$i" != "$second" ] && [ "$i" != "$third" ]; then
        echo "Removing: $i"
        sudo swift-ring-builder /etc/swift/account.builder remove $i
        sudo swift-ring-builder /etc/swift/object.builder remove $i
        sudo swift-ring-builder /etc/swift/container.builder remove $i
    fi
done

sudo swift-ring-builder /etc/swift/object.builder rebalance
sudo swift-ring-builder /etc/swift/account.builder rebalance
sudo swift-ring-builder /etc/swift/container.builder rebalance

for i in $(systemctl | grep swift | awk {'print $1'}); do systemctl restart $i; done
