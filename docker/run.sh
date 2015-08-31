#!/bin/sh
set -e

#arg:
#1 run opts

#to work from any dir
SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR
source ../common.src


dd=`$ENVCMD PROJECT_DIR/docker`
cd $dd
ad=${dd}/`ls -d ./*${2}`

cd $dd
./run $1

