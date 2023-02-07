#!/bin/bash

BASE_DIR="/java-ts"
DOCKER_REPOSITORY="quaki"
DOCKER_IMAGES="java-ts"
DOCKER_TARGET="latest"
HOST_HTTP_PORT=8081
DOCKER_HTTP_PORT=8081
VOLUME=`pwd`
OUTPUT_DIRECTORY="$VOLUME/java-ts"
ENDPOINT_SHELL="$OUTPUT_DIRECTORY/entrypoint.sh"

docker_ps() {
  containerID=`docker ps -a | grep "$DOCKER_REPOSITORY-$DOCKER_IMAGES" | awk '{print $1}'`
  cid=$containerID
}

run() {
  docker_ps
  if [ !$cid ]; then
    build
  fi

  volume=""
  parameter=""

  if [ $# -gt 0 ]; then
    while [ -n "$1" ]; do
      case "$1" in
        -v)
          volume="$volume -v $2"
          shift 2
          ;;
        -p)
          parameter="$parameter -p $2"
          shift 2
          ;;
        *)
          echo "run: arg $1 is not a valid parameter"
          exit
          ;;
      esac
    done

    if [ -z "$volume" ]; then
      volume=" -v $OUTPUT_DIRECTORY:/java-ts"
    fi

    if [ -z "$parameter" ]; then
      parameter=" -p $HOST_HTTP_PORT:$DOCKER_HTTP_PORT"
    fi

    docker run -d -it --name "$DOCKER_REPOSITORY-$DOCKER_IMAGES" \
        $volume \
        $parameter \
        --restart always \
        "$DOCKER_REPOSITORY/$DOCKER_IMAGES:$DOCKER_TARGET"
  else
    docker run -d -it --name "$DOCKER_REPOSITORY-$DOCKER_IMAGES" \
      -v $OUTPUT_DIRECTORY:/java-ts \
      -p $HOST_HTTP_PORT:$DOCKER_HTTP_PORT \
      --restart always \
      "$DOCKER_REPOSITORY/$DOCKER_IMAGES:$DOCKER_TARGET"
  fi
}

build() {
  echo 'docker build'
  if [ ! -f "Dockerfile" ]; then
    echo 'warning: Dockerfile not exists.'
    exit
  fi
  chmod u+rwx $ENDPOINT_SHELL
  chmod u+rwx "$OUTPUT_DIRECTORY/bin/run.sh"
  docker build -t "$DOCKER_REPOSITORY/$DOCKER_IMAGES:$DOCKER_TARGET" .
}

start() {
  docker_ps
  if [ $cid ]; then
    echo "containerID: $cid"
    echo "docker stop $cid"
    docker start $cid
    docker ps
  else
    echo "container not running!"
  fi
}

stop() {
  docker_ps
  if [ $cid ]; then
    echo "containerID: $cid"
    echo "docker stop $cid"
    docker stop $cid
    docker ps
  else
    echo "container not running!"
  fi
}

rm_container() {
  stop
  if [ $cid ]; then
    echo "containerID: $cid"
    echo "docker rm $cid"
    docker rm $cid
    docker_ps
  else
    echo "image not exists!"
  fi
}

case "$1" in
  --start)
    start ${@: 2}
    exit
    ;;
  --stop)
    stop ${@: 2}
    exit
    ;;
  --run)
    run ${@: 2}
    exit
    ;;
  --rm)
    rm_container ${@: 2}
    exit
    ;;
  *)
    echo "arg: $1 is not a valid parameter"
    exit
    ;;
esac
