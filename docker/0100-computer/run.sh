#!/bin/sh
set -e
cd `dirname $0`
source ../../common.src


dd=`$ENVCMD PROJECT_DIR`/tsad
dipy=`$ENVCMD PROJECT_FILES`/.ipython 
djpy=`$ENVCMD PROJECT_FILES`/.jupyter

ls $djpy |: #coaxes the f/s to be ok ..
ls $dipy |: #..with the dot dirs!!!!!!!!!!!
#WHY WHY WHY WHY WHY?!?!?!?!?!?!?!?!?!
mkdir -p ${djpy}/runtime              
mkdir -p ${dipy}/profile_default              
cp ipython_config.py ${dipy}/profile_default
cp jupyter_notebook_config.py ${djpy}

app=${1-ipyengine}
n=${2-1}

for i in $(seq 1 $n)
do
docker stop       `hostname`-${app}-$i | :
docker rm         `hostname`-${app}-$i | :
docker run --name `hostname`-${app}-$i \
       -d \
       --dns 8.8.8.8 \
       -v ${dd}:/data \
       -v ${dipy}:/root/.ipython \
       -v ${djpy}:/root/.jupyter \
       -v /home/core/vld/db:/db \
       -e JUPYTER_RUNTIME_DIR=/root/.jupyter/runtime \
       registry:5000/computer /root/${app}
done
