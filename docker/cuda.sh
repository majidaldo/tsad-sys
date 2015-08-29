#!/bin/sh
set -e

tag=${1:-master}

cd `ls -d docker/*cuda`
git checkout $tag
cd ..

docker build -t base `ls -d docker/*base`
docker build -t cuda `ls -d docker/*cuda`
docker run --privileged --rm cuda

