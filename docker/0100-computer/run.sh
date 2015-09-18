#!/bin/sh
set -e
cd `dirname $0`
source ../../common.src


dd=`$ENVCMD PROJECT_DIR`\tsad

docker stop computer | :
docker rm   computer | :
docker run --name computer -d -v ${dd}:/data registry:5000/computer
