#! /bin/bash

set -eu

message="Hello World"
image_tag="${CI_SO}${CI_SO_VER}_jdk1.${CI_JAVA_MAJOR}_${CI_ZOOK_VER}"
image_name="${CI_IMAGE_NAME}:${image_tag}"

echo_result=`docker run --name ${image_tag}01 ${image_name} echo ${message}`
echo_result2="$(docker run --name ${image_tag}02 ${image_name} echo ${message})"

if [ "$message" != "$echo_result" ]; then   
  exit 1
fi

if [ "$message" != "$echo_result2" ]; then   
  exit 1
fi

docker ps --all --filter 'exited=0' --filter "ancestor=${image_name}" | grep -v "CONTAINER ID"