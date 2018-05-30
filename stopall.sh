#!/usr/bin/env bash

docker rm -fv $(docker ps -aq)
docker system prune -a -f
sudo rm -rf downloads/ m2deps/
