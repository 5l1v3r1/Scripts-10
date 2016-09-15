#!/bin/bash
#
#  Author: Spacecow
#  Date: 06/03/2016
#  Description:
#  Renames files listed in specified text file.
#  File names must be seperated by ->
#
#  Example: $ cat list.txt
#    file_old -> file_new
#    file_old -> file_new


function rename() {
  local ARR=(${1//->/})
  mv "${ARR[0]}" "${ARR[1]}"
}

function main() {
  if [ ${#} -ne 1 ]; then
    printf "${0} <FILE>\n" 1>&2
    exit 1
  fi

  if [ ! -f "${1}" ]; then
    printf "${0}: File Error: File '${1}' not found\n" 1>&2
    exit 2
  fi

  while read LINE; do
    rename "${LINE}"
  done < ${1}
}

main "$@"
