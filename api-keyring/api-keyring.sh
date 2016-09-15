#!/bin/bash
#
#  Author: Spacecow
#  Date: 07/05/2016
#  Description:
#  A simple API key manager.


function create_key() {
  local FOLDER="${1}"
  local KEYS="${2}"
  local KEYNAME="${3}"

  if [ ! -z "$(echo "${KEYS}" | grep "${KEYNAME}.key")" ]; then
    printf "${0}: Key Name Error: Key already exists.\n" 1>&2
    exit 3
  fi
  read -p "${KEYNAME} API Key: " APIKEY
  echo "${APIKEY}" > "${FOLDER}/${KEYNAME}.key"
  exit 0
}

function delete_key() {
  local FOLDER="${1}"
  local KEYS="${2}"
  local KEYNAME="${3}"

  if [ -z "$(echo "${KEYS}" | grep "${KEYNAME}.key")" ]; then
    printf "${0}: Key Name Error: Key not found.\n" 1>&2
    exit 2
  fi
  rm -f "${FOLDER}/${KEYNAME}.key"
  exit 0
}

function show_key() {
  local FOLDER="${1}"
  local KEYS="${2}"
  local KEYNAME="${3}"

  case ${KEYNAME} in
    ALL)
      echo "${KEYS}" | sed s/\.key// | awk '{print $1}'
      exit 0
      ;;
    *)
      if [ -z "$(echo "${KEYS}" | grep "${KEYNAME}.key")" ]; then
        printf "${0}: Key Name Error: Key not found.\n" 1>&2
        exit 2
      fi
      cat "${FOLDER}/${KEYNAME}.key"
      exit 0
      ;;
  esac
}

function main() {
  local FOLDER="${HOME}/.api-keyring"
  if [ ! -d "${FOLDER}" ]; then
    mkdir ${FOLDER}
  fi
  local KEYS=("$(ls ${FOLDER})")
  local KEYNAME="${!#}"
  local ACTION='SHOW'

  while getopts 'hlcds' OPT; do
    case ${OPT} in
      h)
        printf "${0} [-h] [-l] [-c] [-d] [-s] KEY\n"
        printf "\tKEY: Name of key to use if operation requires one.\n"
        printf "\t-h: Show this help text.\n"
        printf "\t-l: List all available keys.\n"
        printf "\t-c: Create a new key.\n"
        printf "\t-d: Delete an existing key.\n"
        printf "\t-s: Show content of an API's key.\n"
        exit 0
        ;;
      l)
          ACTION='LIST'
          ;;
      c)
          ACTION='CREATE'
          ;;
      d)
          ACTION='DELETE'
          ;;
      s)
          ACTION='SHOW'
          ;;
    esac
  done

  case ${ACTION} in
    LIST)
      show_key "${FOLDER}" "${KEYS}" 'ALL'
      ;;
    CREATE)
      create_key "${FOLDER}" "${KEYS}" "${KEYNAME}"
      ;;
    DELETE)
      delete_key "${FOLDER}" "${KEYS}" "${KEYNAME}"
      ;;
    SHOW)
      show_key "${FOLDER}" "${KEYS}" "${KEYNAME}"
      ;;
    *)
      printf "${0}: Action Error: Invalid action provided\n" 1>&2
      exit 1
      ;;
  esac
}


main ${@}
