#!/bin/sh
set -e
cd `dirname $0`
source ../../common.src


#dd=`$ENVCMD PROJECT_FILES`/db
dd=/home/core/vld/db
sudo mkdir -p $dd
cd $dd

docker stop db | :
docker rm   db | :
docker run \
       --name db \
       --dns 8.8.8.8 \
       -d \
       -v `pwd`:/data/db \
       registry:5000/mongodb
