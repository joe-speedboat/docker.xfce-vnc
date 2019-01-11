
FROM consol/ubuntu-xfce-vnc:latest
LABEL maintainer="Chris Ruettimann <chris@bitbull.ch>"

# change user for modifications
USER root

# Install custom software
RUN apt-get update && \
    apt-get install -y geany geany-plugins-common \
                      libreoffice \
                      pinta \
	              evince && \
                      apt-get clean -y && \
                      cp -f /headless/noVNC/vnc.html /headless/noVNC/index.html

COPY che.png /headless/.config/bg_sakuli.png

# keep this from underlying container
EXPOSE 6901/TCP

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8' \
    DISPLAY=:1 \
    HOME=/headless \
    TERM=xterm \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=/headless/install \
    NO_VNC_HOME=/headless/noVNC \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x1024 \
    VNC_PW=vncpassword \
    VNC_VIEW_ONLY=false

WORKDIR $HOME

USER 1000

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]
