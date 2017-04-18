#! /bin/bash


template_folder="./source/${CI_SO}"
tag="${CI_SO}${CI_SO_VER}_jdk1.${CI_JAVA_MAJOR}_${CI_ZOOK_VER}"
dockerfile_folder="./Dockerfiles/${CI_SO}${CI_SO_VER}/jdk1.${CI_JAVA_MAJOR}/${CI_ZOOK_VER}"
dockerfile_path="${dockerfile_folder}/Dockerfile"

mkdir -p $dockerfile_folder

cp "./source/${CI_SO}"/* "${dockerfile_folder}/"
cp "./source/common"/* "${dockerfile_folder}/"

ci_env_vars=`env | awk 'match($0, /(CI_.*)=/) {print substr($0, RSTART, RLENGTH-1)}'`

for var_name in $ci_env_vars; do
    sed -ie "s/:${var_name}:/${!var_name}/g" $dockerfile_path
done

docker build --tag "${CI_IMAGE_NAME}:${tag}" $dockerfile_folder



