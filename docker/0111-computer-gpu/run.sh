#!/bin/sh
set -e
cd `dirname $0`
source ../../common.src


dd=`$ENVCMD PROJECT_DIR`\tsad

docker stop computer-gpu | :
#docker rm   computer-gpu | :
docker run --name computer-gpu -d -v ${dd}:/data registry:5000/computer-gpu
