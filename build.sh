#!/bin/sh -e
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
IMAGE=$(cat IMAGE)
IMAGE_FROM=$(cat IMAGE_FROM)
VERSION=$(cat VERSION)

cd $(dirname $0) 
sed -i "s@^FROM .*@FROM $IMAGE_FROM:$VERSION@" Dockerfile

docker build -t $IMAGE:$VERSION .

