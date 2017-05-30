#!/bin/bash
set -eu

IMAGE="sebastianhallen/node-request-echo"

function nukeContainer() {
  IMAGE_ID=$(docker images -q "${IMAGE}")
  EXISTING_CONTAINER=$(docker ps -q -f "ancestor=${IMAGE_ID}")
  if [[ $EXISTING_CONTAINER != "" ]]; then
    echo "terminating container"
    docker stop "${EXISTING_CONTAINER}"
    docker rm "${EXISTING_CONTAINER}"
  fi
}

function testContainer() {
  COMMAND="curl -q localhost:8080/some-path/ 2> /dev/null"
  hash docker-machine && {
    RESPONSE=$(docker-machine ssh default -C "${COMMAND}")
  }
  hash docker-machine || {
    RESPONSE=$(eval "${COMMAND}")
  }

  echo "Response: ${RESPONSE}"
}

nukeContainer

docker run -dit -p 8080:80 "${IMAGE}"
sleep 3
testContainer
