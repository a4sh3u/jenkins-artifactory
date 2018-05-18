#!/usr/bin/env bash

docker rm -fv $(docker ps -aq)
docker rmi -f myjenkins
docker volume prune -f
docker network prune -f
rm -rf downloads/ m2deps/
