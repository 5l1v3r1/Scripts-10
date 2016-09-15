#!/bin/bash
#
#  Author: Spacecow
#  Date: 06/03/2016
#  Description:
#  Manage and write script templates.


function main()
{
  local FOLDER="${HOME}/.template"
  local TEMPLATES=($(ls ${FOLDER}))
  local DEST="${!#}"
  local TYPE=

  if [ ! -d "${FOLDER}" ]; then
    mkdir ${FOLDER}
  fi

  while getopts 'hlt:' OPT; do
    case ${OPT} in
      h)
        printf "${0} [-h] [-l] -t TYPE FILE\n"
        printf "\t-l: List available templates in ${FOLDER}\n"
        printf "\t-t TYPE: Template type to create\n"
        printf "\tFILE: Path to file to write template to\n"
        exit 0
        ;;
      l)
        ls ${FOLDER}
        exit 0
        ;;
      t)
        TYPE="${OPTARG}"
        ;;
    esac
  done

  if [ -z "${TYPE}" ]; then
    printf "${0}: Type Error: No type provided\n" 1>&2
    exit 1
  fi

  if [ -z "$(echo "${TEMPLATES[*]}" | grep "${TYPE}")" ]; then
    printf "${0}: Invalid Type: '${TYPE} not valid type'\n" 1>&2
    exit 2
  fi

  cp "${FOLDER}/${TYPE}" "${DEST}"
}

main "${@}"
