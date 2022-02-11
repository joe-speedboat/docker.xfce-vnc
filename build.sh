#!/bin/sh -e
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
REG=docker.io/christian773/xfce-vnc
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

echo "Done,
If you want to push this release with stable tag as well,
do your testing now and hit <ENTER>.
If not, type <CTRL>+<C>"
read x
docker tag $REG:$VERSION $REG:stable
docker push $REG:stable
