#!/usr/bin/env bash
VERSION="master"
NAME="admidio"
BARG=""
if [ ! -z "$1" ]; then
	VERSION="$1"
	BARG="--build-arg branch=$1"
fi

echo "starting Build"
docker build -t $NAME:$VERSION $BARG .
echo "build finished"
echo "you can now starting the docker image with following Command"
echo "docker run -it --restart always --name $NAME -p 8080:80 -v <local docker volume>:/var/www/admidio/adm_my_files $NAME:$VERSION"
