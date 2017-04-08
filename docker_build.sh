#!/usr/bin/env bash
VERSION="3.2.8"
NAME="admidio"

echo "starting Build"
docker build -t $NAME:$VERSION .
echo "build finished"
echo "you can now starting the docker image with following Command"
echo "docker run -it --restart always --name $NAME -p 8080:80 -v <local docker volume>:/var/www/admidio/adm_my_files $NAME:$VERSION"
