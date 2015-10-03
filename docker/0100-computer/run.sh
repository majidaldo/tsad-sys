#!/bin/sh
set -e
cd `dirname $0`
source ../../common.src


dd=`$ENVCMD PROJECT_DIR`\tsad
dipy=`$ENVCMD PROJECT_FILES`/.ipython
mkdir -p $dipy

for i in $(seq 1 `nproc`)
do

docker stop       computer-$i | :
docker rm         computer-$i | :
docker run --name computer-$i \
       -d \
       -v ${dd}:/data \
       -v ${dipy}:/root/.ipython \
       registry:5000/computer #$1
done
