#!/bin/sh
set -e
SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR
source ../../common.src


ad=`$ENVCMD PROJECT_DIR`\tsad

di=${REGISTRY_HOST}/theano
docker pull $di
docker stop theano | :
docker rm   theano | :
#start ipython notebook
docker run --name theano \
       --dns 8.8.8.8 \
       -d -v ${ad}:/data $di 
