# Introduction
We deployed a shiny-app that demonstrate acmt-network. Note that the geocoder and mapper sends data to openstreetmap and is not private.

This also implements a few functionalities that would otherwise not achievable without shiny-server pro. Multiple Docker containers, each hosting the same shiny-app, are created to parallel shiny-app serving. Connection time out and load-balancing over the containers are also enabled using HAProxy.

Below describes the steps for future reference.

## Install the app for acmt-network
0. `screen -r run_acmt_network`
1. Download `acmt-network` with `git clone https://github.com/2533245542/acmt-network.git`.
2. `cd  acmt-network`
3. Open `vim src/app/Dockerfile`. Uncomment the following lines of code.
```
#RUN R -e "install.packages(c('shiny', 'shinythemes', 'tidygeocoder'))"
#RUN yes | apt-get install gdebi-core
#RUN wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.16.958-amd64.deb
#RUN yes | gdebi shiny-server-1.5.16.958-amd64.deb
#RUN git clone https://github.com/2533245542/acmt-shiny.git /srv/shiny-server/acmt_shiny
#RUN sed -i '2s/.*/run_as rstudio;/' /etc/shiny-server/shiny-server.conf
#RUN sed -i '17s#.*#path <- "http://172.17.0.1:5000/latlong?"#' /home/rstudio/workspace/GeocoderACMT.R
#RUN sed -i '49s#.*#acs_columns_url <- "http://172.17.0.1:7000/ACSColumns.csv"#' /home/rstudio/workspace/GeocoderACMT.R
#CMD shiny-server
```

4. Run `acmt-network` with `docker compose -f docker-compose.yml -f docker-compose.shiny.yml up --build` in this screen and put the screen to background.

5. Try these websites:
`acmt.csde.washington.edu`
`acmt.csde.washington.edu:8000/acmt_shiny`
`acmt.csde.washington.edu:8000`
`acmt.csde.washington.edu:8000/sample-apps/hello/`

Note that the terminal has to be remained open for serving the app (but not if the sys rebbot and auto start-up launch is enabled).

## schedule daily system reboot and launch acmt-shiny at system start-up
Run `crontab -e` and add the below lines to the end of the file, save.

```
00 1 * * * sudo shutdown -r
@reboot cd /home/wzhou87/deploy/acmt-network;docker compose -f docker-compose.yml -f docker-compose.shiny.yml up --build
```

The first line schedules a system reboot daily at 1am; the second runs acmt-shiny at start-up

## enable connection time out and load balancing
Add to the end of the file
```/etc/haproxy/haproxy.cfg
backend shiny_backend
       mode http
       balance leastconn
       timeout connect 300s
       timeout client 300s
       timeout server 300s # the one that decides the time out
       server shiny_backend_1   127.0.0.1:8000
       server shiny_backend_2   127.0.0.1:8080
       server shiny_backend_3   127.0.0.1:8081
       server shiny_backend_4   127.0.0.1:8082
       server shiny_backend_5   127.0.0.1:8083
```

## other commands
### see log 
`cd /var/log/shiny-server`
### make a port open
`systemctl stop shiny-server`
### nginx
`nginx -s reload`
`vim /etc/nginx/nginx.conf`
`nginx -s stop`
### docker images and containers operation
#### stop all running containers
`docker stop $(docker ps -aq)`
#### remove all containers 
`docker rm $(docker ps -aq)`
#### remove an image
`docker rmi acmt-network_app`
#### remove a container
```
docker stop acmt-network-app-1
docker rm acmt-network-app-1
docker stop acmt-network-app1-1
docker rm acmt-network-app1-1
```

### enter a running container
`docker exec -it acmt-network-app-1 /bin/bash`

### haproxy
start proxy with `sudo service haproxy start`, start app with `docker compose up --build`, 8080 does not work when accessing with `http://acmt.csde.washington.edu:8080/acmt_shiny`, 443 also not work when accessing with `http://acmt.csde.washington.edu:443`
stop proxy with `sudo service haproxy stop`, start app with `docker compose up --build`, 8080 works when accessing with `http://acmt.csde.washington.edu:8080/acmt_shiny`, 443 not work when accesing with `http://acmt.csde.washington.edu:443`, start proxy, 8000 and 8080 still works, 443 still not work
`sudo systemctl reload haproxy`

`sudo service haproxy stop;sudo service haproxy start`

## miscelanous
### Restart the app after a server shutdown
1. `screen -S run_acmt_network`
2. run `systemctl stop shiny-server` to close port 8000 if opened previously
3. in `acmt-network`, run `docker compose up --build`

### Uninstall the app on the server
`docker system prune -a --volumes --force` since this is the only Docker process we run on the server.

### Start the app for testing
In `global.R`, set `acmt_network_path <- "../local_acmt_network_development/local_acmt_network_v0.0.10/"` to the path to the location of the ACMT source files.

In `acmt-shiny`, do

```
library(shiny)
runApp()
```

### Install acmt-shiny directly on the server
0. Install prerequisites following `acmt-network/src/app/Dockerfile` (`tidyverse`, `libudunits2-dev`, `libgdal-dev`, `R -e "install.packages(c('geosphere', 'lwgeom', 'raster', 'sf', 'tidycensus', 'tigris', 'units', 'USAboundaries', 'reshape2', 'rgeos', 'osrm', 'leaflet'))"`, `R -e "install.packages(c('shiny', 'shinythemes', 'tidygeocoder'))"`, `gdebi-core`, `shiny-server`)
1. download acmt-shiny with `sudo git clone https://github.com/2533245542/acmt-shiny.git /srv/shiny-server/acmt_shiny`
2. download acmt-network with `git clone https://github.com/2533245542/acmt-network.git ~/direct_deploy/acmt_network`
3. `vim acmt_network/src/app/workspace/GeocoderACMT.R`, set `enable_connection_to_docker_network` to `FALSE` and comment out 
```
        download.file(url = "http://sandbox.idre.ucla.edu/mapshare/data/usa/other/spcszn83.zip", destfile = "ACMT/spcszn83.zip")
        unzip("ACMT/spcszn83.zip", exdir="ACMT")
        download.file(url = "https://www2.census.gov/geo/tiger/GENZ2017/shp/cb_2017_us_county_500k.zip", destfile = "ACMT/cb_2017_us_county_500k.zip")
        unzip("ACMT/cb_2017_us_county_500k.zip", exdir="ACMT")
```
4. `sudo vim /srv/shiny-server/acmt_shiny/global.R` to set the path to `~/direct_deploy/acmt_network/src/app/workspace`
5. `sudo vim /etc/shiny-server/shiny-server.conf` to set `run_as wzhou87` and `listen 8000`.
6. run `shiny-server` to start the shiny server.

