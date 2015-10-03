#!/bin/sh
cd /data

for i in {1..`nproc`}
do
    ipengine
done
#ipython notebook --ip=* --no-browser 




