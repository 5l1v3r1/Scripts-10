#!/bin/bash
################################################################################
# Title:   RFC                                                                 #
# Author:  Spacecow                                                            #
# License: GPLv3                                                               #
# Date:    19/10/14                                                            #
# Description:                                                                 #
#   Manage a local mirror of RFCs from rfc-editor.org using rsync.             #
#   Search through them by number and view using less.                         #
#   Sort of like man pages for RFCs.                                           #
################################################################################

# Location to store local RFC copies.
RFC_STORAGE="/tmp/my-rfc-mirror"


function update_rfcs() {
  echo "[   OK   ]  Updating local RFC mirror. This may take a while!"
  sleep 3
  rsync -avz --delete ftp.rfc-editor.org::rfcs-text-only "$RFC_STORAGE"

  if [ $? -ne 0 ]; then
    echo "$0: RFC update error: update finished with error-code $?" 1>&2
    exit 2
  else
    echo "[   OK   ]  RFC update was successfull."
  fi
}


function search_rfcs(RFC) {
  false
}


if [ $# -lt 1 -o $# -gt 2 ]; then
  echo "$0: Argument length error: improper number of arguments provided" 1>&2
  echo "Usage: $0 [--help] [--update] [number]"
  exit 1
fi

# First run setup
if [ -z "$RFC_STORAGE" ]; then  # Create our initial local copy
  echo "[  Fail  ]  Could not find local RFC mirror." 1>&2
  if [ "$1" != '--help' -o "$1" != '-h' ]; then
    read -p "Would you like to initialize a local mirror?[y/N] " OPT
    if [ "$OPT" = 'y' ]; then
      update_rfcs
    else
      exit 0
    fi
  fi
fi


if [ "$1" = '--help' -o "$2" = '--help' ]; then
  echo "Usage: $0 [--help] [--update] [number]"
  exit 0
  
elif [ "$1" = '--update' -o "$2" = '--update' ]; then
  updates_rfcs
fi

search_rfcs $(echo "$*" | sed s/--update// | awk 'print $1')
