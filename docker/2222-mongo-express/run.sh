#!/bin/bash
#set -e

docker rm -f mongo-express
docker run -d  \
	--name mongo-express \
	--link mongodb:mongo \
	-e ME_CONFIG_MONGODB_SERVER='mongodb' \
	-p 127.0.0.1:8081:8081 \
	mongo-express "$@"
