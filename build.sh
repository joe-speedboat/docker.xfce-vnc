#!/bin/sh -e
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
IMAGE=$(cat IMAGE)
VERSION=$(cat VERSION)

cd $(dirname $0) 
sed -i "s@^FROM .*@FROM $IMAGE:$VERSION@" Dockerfile

docker build -t $IMAGE:$VERSION .

