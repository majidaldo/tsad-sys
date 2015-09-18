#!/bin/sh
set -e


docker build -t cuda `ls -d ./*cuda`
docker run --privileged --rm cuda #registry:5000/cuda

