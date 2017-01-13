#!/bin/bash
#
# This is to setup the etherstub and virtual switches/natting
# Maintainer: scoday@$$$.com #

# Define Variables:
IPSUBNET=192.168.1.0/24
IPGW=192.168.1.254
HOSTNAME=hnd-zgw01
ZONELOC="/zones/ScoZone/01/"

addstub() {
  dladm create-etherstub etherstub0
  dladm show-etherstub
}

addvnics() {
  for i in {0,1,2}; do dladm create-vnic -l etherstub0 vnic$i; done
  dladm show-vnic
}

addipplub() {
  echo "$IPGW    $HOSTNAME" >> /etc/hosts
  ifconfig vnic0 plumb
  ifconfig vnic0 $HOSTNAME netmask + broadcast + up
  ifconfig vnic0
}

# Add intelligence here for building out ZoneZ #

configuredns() {
  # Add variable for ZONE locatoin #
  cp /etc/nsswitch.conf /zones/ScoZone/01/root/etc
  cp /etc/resolv.conf /zones/ScoZone/01/root/etc
}

enablenat() {
  routeadm -u -e ipv4-forwarding
  echo "map net1 $IPSUBNET -> 0.0.0.0/32 portmap tcp/udp auto" >> /etc/ipf/ipnat.conf
  echo "map net1 $IPSUBNET -> 0.0.0.0/32" >> /etc/ipf/ipnat.conf
}

startfilter() {
  svcadm enable network/ipfilter
  ipnat -l
}


