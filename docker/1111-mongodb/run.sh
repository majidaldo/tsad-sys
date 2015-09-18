#!/bin/sh
set -e
cd `dirname $0`
source ../../common.src


#dd=`$ENVCMD PROJECT_FILES`/db
dd=/home/core/vld/db
sudo mkdir -p $dd
cd $dd

docker stop mongodb | :
docker rm   mongodb | :
docker run \
       --name mongodb \
       --dns 8.8.8.8 \
       -d \
       -v `pwd`:/data/db \
       -p 27017:27017 \
       registry:5000/mongodb
