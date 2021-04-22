#!/bin/bash
# setup noVNC classroom with shared storage and create inventory file with access links within OpenShift 4.x

PROJECT=classroom
NR=3 #nr of desktops to deploy

# internal openshift wildcard domain
DOMAIN=lab.acme.org

# hostname pattern 
HOST=student

oc new-project $PROJECT
> $PROJECT-inventory.txt

seq -w $NR | while read NR
do
   URL=$HOST$NR.$DOMAIN
   PASSWORD=$(uuidgen  | sed 's/-//g')
   oc new-app --name=$HOST$NR --docker-image=docker.io/christian773/xfce-vnc:latest VNC_PW=$PASSWORD
   oc set volume deployment/$HOST$NR --add --name=$PROJECT -t pvc --overwrite --claim-size=5G --claim-mode=ReadWriteMany --mount-path=/headless/Desktop/data --claim-name=$PROJECT
      oc create route edge --service $HOST$NR --hostname=$URL --port=6901
   echo "https://$URL?password=$PASSWORD&true_color=1&reconnect=1&autoconnect=1&resize=remote" >> $PROJECT-inventory.txt
done
cat $PROJECT-inventory.txt
