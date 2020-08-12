# docker.xfce-vnc
this is an xfce desktop which is intended to to be used for teaching env

## BUILD
```
vim VERSION
sh build.sh
```

## RUN
```
docker run --env VNC_PW=secure. --env DEBUG=true --expose 6901 christian773/xfce-vnc:stable
```


## ScreenShot
![](ss.png)
