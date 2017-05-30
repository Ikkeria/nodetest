#!/bin/bash
set -eu

PROGNAME=$(basename "$0")
SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function usage() {
  cat << EOL

    $PROGNAME:
      creates a docker images from the Dockerfile in the current directory

    Usage:
      $PROGNAME --repository repository --tag latest

    Where:
      -r|--repository)          Name of the image repository.

      -t|--tag)                 Tag name for the image.

      -p|--push)                Push built image.

      -h|--help)                Show help.
EOL
}

# Transform long options to short ones
for ARG in "$@"; do
  shift;
  case "${ARG}" in
    "--help")                 set -- "$@" "-h" ;;
    "--repository")           set -- "$@" "-r" ;;
    "--tag")                  set -- "$@" "-t" ;;
    "--push")                 set -- "$@" "-p" ;;
    *)
      if [[ $ARG == --* ]]; then
        error "Invalid option ${ARG}" >&2
        usage
        exit 1
      fi
      set -- "$@" "${ARG}"
      ;;
  esac
done

function error() {
  MESSAGE=$1
  (>&2 echo "${MESSAGE}")
}

REPOSITORY=""
TAG="latest"
PUSH="false"

OPTIND=1
while getopts ":r:t:ph-" OPT; do
  case "$OPT" in
    r) REPOSITORY="${OPTARG}"; ;;
    t) TAG="${OPTARG}"; ;;
    p) PUSH="true"; ;;
    h)
      usage
      exit 0
      ;;
    \?)
      error "Invalid option ${OPTARG}"
      usage
      exit 1
      ;;
    :) 
      error "Option -${OPTARG} requires an argument."
      usage
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

# check for missing or faulty arguments
MISSING_ARGUMENTS=()
if [[ "${REPOSITORY}" == "" ]]; then
  MISSING_ARGUMENTS+=( "argument -r|--repository) is required." )
fi

# missing/faulty arguments detected, show validation errors and usage
if [[ ${#MISSING_ARGUMENTS[@]} -gt 0 ]]; then
  for e in "${MISSING_ARGUMENTS[@]}"; do
    error "$e"
  done

  echo
  usage
  exit 1
fi

pushd "${SCRIPT_DIRECTORY}" > /dev/null
trap "popd > /dev/null" EXIT

docker build -t "${REPOSITORY}:${TAG}" .

if [[ $PUSH == "true" ]]; then
  docker push "${REPOSITORY}:${TAG}"
fi
