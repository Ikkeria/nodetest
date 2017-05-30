#!/bin/bash
set -eu

IMAGE="sebastianhallen/node-http-echo"
PORT="1337"

PROGNAME=$(basename "$0")
SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function usage() {
  cat << EOL

    $PROGNAME:
      Builds (optional) and tests http calls to a docker container.

    Usage:
      $PROGNAME --build

    Where:
      -p|--protocol)            HTTP, HTTPS, or HTTP2, default HTTP
      -b|--build)               Build the image before testing
      -h|--help)                Show help.
EOL
}

function error() {
  MESSAGE=$1
  (>&2 echo "${MESSAGE}")
}


# Transform long options to short ones
for ARG in "$@"; do
  shift;
  case "${ARG}" in
    "--help")                 set -- "$@" "-h" ;;
    "--protocol")             set -- "$@" "-p" ;;
    "--build")                set -- "$@" "-b" ;;
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

BUILD="false"
PROTOCOL="HTTP"
OPTIND=1
while getopts ":p:bh-" OPT; do
  case "$OPT" in
    b) BUILD="true"; ;;
    p) PROTOCOL="${OPTARG}"; ;;
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

function nukeContainer() {
  IMAGE_ID=$(docker images -q "${IMAGE}")
  EXISTING_CONTAINER=$(docker ps -q -f "ancestor=${IMAGE_ID}")
  if [[ $EXISTING_CONTAINER != "" ]]; then
    echo "terminating container..."
    docker stop "${EXISTING_CONTAINER}"
    docker rm "${EXISTING_CONTAINER}"
  fi
}

function testContainer() {
  if [[ $PROTOCOL == "http" ]]; then
    COMMAND="curl -q http://localhost:${PORT}/some-path/ 2> /dev/null"
  else
    COMMAND="curl -q -k https://localhost:${PORT}/some-path/ 2> /dev/null"
  fi
  
  hash docker-machine && {
    RESPONSE=$(docker-machine ssh default -C "${COMMAND}")
  }
  hash docker-machine || {
    RESPONSE=$(eval "${COMMAND}")
  }

  echo "Response: ${RESPONSE}"
}

nukeContainer

if [[ $BUILD == "true" ]]; then
  ./build-image.sh --repository "${IMAGE}" --tag "latest"
fi

docker run -dit  -e PROTOCOL="${PROTOCOL}" -p "${PORT}:${PORT}" "${IMAGE}"
sleep 3
testContainer
nukeContainer