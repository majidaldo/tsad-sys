#!/bin/sh
set -e
source ../../common.src

#dd=`$ENVCMD PROJECT_FILES`\data\app
#mkdir -p $dd

docker stop ipy-nb
docker rm   ipy-nb
docker run --name ipy-nb --rm -t -v `pwd`:/data ipy-nb
