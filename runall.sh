#!/usr/bin/env bash

function getContainerPort() {
    echo $(docker port $1 | sed 's/.*://g')
}

if [ ! -d downloads ]; then
    mkdir downloads
    curl -o downloads/jdk-8u131-linux-x64.tar.gz http://ftp.osuosl.org/pub/funtoo/distfiles/oracle-java/jdk-8u131-linux-x64.tar.gz
    curl -o downloads/jdk-7u76-linux-x64.tar.gz http://ftp.osuosl.org/pub/funtoo/distfiles/oracle-java/jdk-7u76-linux-x64.tar.gz
    curl -o downloads/apache-maven-3.5.0-bin.tar.gz http://apache.mirror.anlx.net/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz
fi

docker build -t myjenkins .

docker run  -d --rm -p 8081 --name artifactory  docker.bintray.io/jfrog/artifactory-oss:5.4.4

artifactory_port=$(getContainerPort artifactory)

IP='localhost'

if [ ! -d m2deps ]; then
    mkdir m2deps
fi

docker run -d -p 8080 -v `pwd`/downloads:/var/jenkins_home/downloads \
    -v `pwd`/jobs:/var/jenkins_home/jobs/:rw \
    -v `pwd`/m2deps:/var/jenkins_home/.m2/repository/ --rm --name myjenkins \
    -e ARTIFACTORY_URL=http://${IP}:${artifactory_port}/artifactory/example-repo-local \
    myjenkins:latest

echo "Artifactory is running at http://${IP}:${artifactory_port}"
echo "Jenkins is running at http://${IP}:$(getContainerPort myjenkins)"
