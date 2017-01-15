#!/bin/ksh

# Create a zone with a VNIC
# Usage:
# createzone <zone name> <VNIC>

  if [ $# != 2 ]
  then
      echo "Usage: createzone <zone name> <VNIC>"
      exit 1
  fi

ZONENAME=$1
VNICNAME=$2

zonecfg -z $ZONENAME > /dev/null 2>&1 << EOF
create
set autoboot=true
set limitpriv=default,dtrace_proc,dtrace_user,sys_time
set zonepath=/zones/$ZONENAME
add fs
set dir=/usr/local
set special=/usr/local
set type=lofs
set options=[ro,nodevices]
end
add net
set physical=$VNICNAME
end
verify
exit
EOF
if [ $? == 0 ] ; then
echo "Successfully created the $ZONENAME zone"
else
echo "Error: unable to create the $ZONENAME zone"
exit 1
fi
