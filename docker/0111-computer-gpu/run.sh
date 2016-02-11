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

NV_DEVICES=`sudo $($ENVCMD PROJECT_DIR)/docker/0110-cuda/devices/nvidia_devices.sh`
	     
for i in $(seq 1 $n)
do
docker stop       `hostname`-gpu-${app}-$i | :
docker rm         `hostname`-gpu-${app}-$i | :
docker run --name `hostname`-gpu-${app}-$i \
       -d \
       -v ${dd}:/data \
       -v ${dipy}:/root/.ipython \
       -v ${djpy}:/root/.jupyter \
       -v /home/core/fs/db:/db \
       -e JUPYTER_RUNTIME_DIR=/root/.jupyter/runtime \
       $NV_DEVICES \
       registry:5000/computer-gpu /root/${app}
#       --dns 8.8.8.8 \
done
