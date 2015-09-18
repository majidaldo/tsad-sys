#!/bin/sh

#args:
#1. machines
#2. app
#3. run opts

set -e
source ../common.src
rdd=`$ENVCMD PROJECT_DIR/docker remote`
ldd=`$ENVCMD PROJECT_DIR/docker`
cd $ldd
dad=${rdd}/`ls -d ./*${2}`

cmd="${dad}/run.sh ${3}"
ssh ${1} /bin/sh -ctl "${cmd}"  > /dev/null 
ssh ${1} "/opt/bin/weave expose" > /dev/null
ssh ${1} /opt/bin/weave ps $2
echo `ssh ${1} /opt/bin/weave ps ${2} | \
      grep -o -e '[0-9]*.[0-9]*.[0-9]*.[0-9]*/' | sed 's/\///'`


