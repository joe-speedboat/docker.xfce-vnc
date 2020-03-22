#!/bin/sh -e
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
REG=docker.io/christian773/xfce-vnc
REG_PATT=$(echo $REG | cut -d/ -f2-)
VERSION=$(cat VERSION)
RELEASE=latest
if [ "$1" == '-s' ]
then
   RELEASE=stable
fi

echo "--------------------------------------------------
INFO: Building Release: $RELEASE   /   VERSION: $VERSION
--------------------------------------------------
"

test -f Dockerfile || (echo "ERROR: Dockerfile not found" ; exit 1)
sed -i "s/^ENV REFRESHED_AT.*/ENV REFRESHED_AT $(date '+%Y-%m-%d-%H:%M')/" Dockerfile
sed -i "s/^ENV VERSION.*/ENV VERSION $VERSION/" Dockerfile

git add -A
git commit -a -m "automated build, RELEASE: $RELEASE"

if [ "$1" == '-s' ]
then
   docker system prune -a -f
   docker build -t $REG:$RELEASE -t $REG:$VERSION .
else
   docker build -t $REG:$RELEASE -t $REG:$VERSION --build-arg CACHEBUST=$(date +%s) .
fi
docker push $REG:$RELEASE
docker push $REG:$VERSION

