#!/bin/sh -e
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin

docker build -t christian773/xfce-vnc:latest --build-arg CACHEBUST=$(date +%s) .

