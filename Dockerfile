# This Dockerfile is used to build an headles vnc image based on Ubuntu

FROM ubuntu:latest

MAINTAINER Chris Ruettimann "chris@bitbull.ch"
ENV REFRESHED_AT 2019-09-14

LABEL io.k8s.description="Headless VNC Container with Xfce window manager" \
      io.k8s.display-name="Headless VNC Container based on Ubuntu" \
      io.openshift.expose-services="6901:http,5901:xvnc" \
      io.openshift.tags="vnc, ubuntu, xfce" \
      io.openshift.non-scalable=true

## Connection ports for controlling the UI:
# VNC port:5901
# noVNC webport, connect via http://IP:6901/?password=vncpassword
ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901
EXPOSE $VNC_PORT $NO_VNC_PORT

USER root
### Envrionment config
ENV HOME=/headless \
    TERM=xterm \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=/headless/install \
    NO_VNC_HOME=/usr/share/novnc/utils \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x1024 \
    VNC_PW=vncpassword \
    VNC_VIEW_ONLY=false \
    LANG='en_US.UTF-8' \
    LANGUAGE='en_US:en' \
    LC_ALL='en_US.UTF-8'

WORKDIR $HOME

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get install -y \
    chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg \
    geany geany-plugins-common \
    firefox \
    libreoffice \
    libnss-wrapper \
    gettext \
    pinta \
    openssh-client \
    openssl \
    dnsutils \
    curl \
    wget \
    rsync \
    whois \
    netcat \
    nmap \
    vim \
    wget \
    net-tools \
    locales \
    bzip2 \
    python-numpy \
    ttf-wqy-zenhei \
    supervisor \
    xfce4 \
    xfce4-terminal \
    xterm \
    tigervnc-common \
    tigervnc-standalone-server \
    novnc \
    websockify \
    evince && \
    apt-get purge -y pm-utils xscreensaver* && \
    apt-get -y clean


### Install xvnc-server & noVNC - HTML5 based VNC viewer
RUN chmod +x -v $NO_VNC_HOME/utils/*.sh && \
    cp -f $NO_VNC_HOME/vnc_auto.html $NO_VNC_HOME/index.html

### inject files
ADD ./src/xfce/ $HOME/
ADD ./src/scripts $STARTUPDIR

### configure startup and set perms
RUN echo "source $STARTUPDIR/generate_container_user >/dev/null 2>&1" > $HOME/.bashrc && \
    echo "CHROMIUM_FLAGS='--no-sandbox --start-maximized --user-data-dir'" > $HOME/.chromium-browser.init && \
    find $STARTUPDIR $HOME -name '*.sh' -exec chmod a+x {} + && \
    find $STARTUPDIR $HOME -name '*.desktop' -exec chmod a+x {} + && \
    chgrp -R 0 $STARTUPDIR $HOME && \
    chmod -R a+rw $STARTUPDIR $HOME && \
    find $STARTUPDIR $HOME -type d -exec chmod a+x {} + && \
    echo LANG=en_US.UTF-8 > /etc/default/locale && \
    locale-gen en_US.UTF-8


USER 1000

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]



