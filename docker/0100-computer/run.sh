#!/bin/sh
set -e
cd `dirname $0`
source ../../common.src


dd=`$ENVCMD PROJECT_DIR`\tsad
dipy=`$ENVCMD PROJECT_FILES`/.ipython
mkdir -p $dipy

docker stop computer | :
docker rm   computer | :
docker run --name computer \
       -d \
       -v ${dd}:/data \
       -v ${dipy}:/root/.ipython \
       registry:5000/computer $1
       

