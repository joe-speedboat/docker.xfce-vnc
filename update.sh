#!/bin/bash

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
cd /etc/git/docker.xfce-vnc
echo $(cat VERSION | cut -d. -f1-2).$(( 1 + $(cat VERSION  | cut -d. -f3 ))) > VERSION
REG=docker.io/christian773/xfce-vnc
REG_PATT=$(echo $REG | cut -d/ -f2-)
VERSION=$(cat VERSION)
RELEASE=latest

echo "--------------------------------------------------
INFO: Building Release: $RELEASE   /   VERSION: $VERSION
--------------------------------------------------
"

test -f Dockerfile || (echo "ERROR: Dockerfile not found" ; exit 1)
sed -i "s/^ENV REFRESHED_AT.*/ENV REFRESHED_AT $(date '+%Y-%m-%d-%H:%M')/" Dockerfile
sed -i "s/^ENV VERSION.*/ENV VERSION $VERSION/" Dockerfile

git add -A
git commit -a -m "automated build, RELEASE: $RELEASE"

docker system prune -a -f
docker build -t $REG:$VERSION .
docker tag $REG:$VERSION $REG:$RELEASE
docker push $REG:$RELEASE
docker push $REG:$VERSION


