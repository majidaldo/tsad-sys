#!/bin/sh
set -e
cd `dirname $0`
source ../../common.src


dd=`$ENVCMD PROJECT_FILES`/.ipython
mkdir -p $dd

docker stop ipycontroller | :
docker rm   ipycontroller | :
docker run --name ipycontroller \
       -d \
       -v ${dd}:/root/.ipython \
       registry:5000/ipycontroller
