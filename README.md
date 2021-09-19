# docker.xfce-vnc
This is an xfce desktop which is intended to to be used for teaching env   
It is based on a ubuntu:latest image
You can access the image with vncviewer or webbrowser directly

# This image includes the following software
- xfce desktop
- Libre Office
- Pinta
- Terminator
- Geany
- Visual Studio Code
- Firefox
- Tor Browser
- Git
- OpenSSL
- Nmap
- Ansible
- Screen
- Tmux



## BUILD
```
vim VERSION
sh build.sh
```

## RUN
```
docker run --env VNC_PW=secure. --env DEBUG=true --publish 5901:5901 --publish 6901:6901 christian773/xfce-vnc:latest
```

## OpenShift and OKD
* openshift39x-classroom-setup.sh
* openshift4x-classroom-setup.sh
This scripts provide a oc based setup for a docker classroom within OpenShift and shared storage.   
The images are great for secure Desktops and exploring Docker Containers from within.    
You may need to adjust the routing, but it's not a big deal to get it running if you know what you're doing! :-)   

## ScreenShot
![](ss.png)
