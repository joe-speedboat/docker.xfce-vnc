#!/bin/sh -e
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
REG=docker.io/christian773/xfce-vnc
REG_PATT=$(echo $REG | cut -d/ -f2-)
VERSION=$(cat VERSION)

test -f Dockerfile || (echo "ERROR: Dockerfile not found" ; exit 1)
sed -i "s/^ENV REFRESHED_AT.*/ENV REFRESHED_AT $(date '+%Y-%m-%d-%H:%M')/" Dockerfile
sed -i "s/^ENV VERSION.*/ENV VERSION $VERSION/" Dockerfile

git add -A
git commit -a -m "automated build"

docker system prune -a -f
docker build -t $REG:latest -t $REG:$VERSION --build-arg CACHEBUST=$(date +%s) .
docker push $REG:latest
docker push $REG:$VERSION

