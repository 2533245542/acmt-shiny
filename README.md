# Start the app for testing
In `global.R`, set `acmt_network_path <- "../local_acmt_network_development/local_acmt_network_v0.0.10/"` to the path to the location of the ACMT source files.

In `acmt-shiny`, do

```
library(shiny)
runApp()
```


# Start the app for server
Put this folder into `/srv/shiny-server`.

Open a terminal and run `shiny-server`

# Start the app for acmt-network
1. Download `acmt-network`.

2. Open `acmt-network/src/app/Dockerfile`. Uncomment the following lines of code.
```
#RUN R -e "install.packages(c('shiny', 'shinythemes', 'tidygeocoder'))"
#RUN yes | apt-get install gdebi-core
#RUN wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.16.958-amd64.deb
#RUN yes | gdebi shiny-server-1.5.16.958-amd64.deb
#RUN git clone https://github.com/2533245542/acmt-shiny.git /srv/shiny-server/acmt_shiny
```

2.1 Edit `.env` to remove the comments.

3. Run `acmt-network` with `docker-compose up --build` in one terminal.

4. After the previous command runs to complete, open another terminal, run `docker exec -it acmt-network_app_1 /bin/bash` to enter the `network_app_1` container.

5. In the `network_app_1` container, edit `/etc/shiny-server/shiny-server.conf`. Change user from `shiny` to `rstudio` with `vim /etc/shiny-server/shiny-server.conf`.

6. Also, in `GeocoderACMT.R`, in line 16, change  
`path <- "http://host.docker.internal:5000/latlong?"`
to
`path <- "http://172.17.0.1:5000/latlong?"`

In line 44, change 
`acs_columns_url <- "http://host.docker.internal:7000/ACSColumns.csv"`
to 
`acs_columns_url <- "http://172.17.0.1:7000/ACSColumns.csv"`

7. Inside the `network_app_1` container, run `shiny-server` in the terminal.

9. Try these websites:
`acmt.csde.washington.edu:8000`
`acmt.csde.washington.edu:8000/sample-apps/hello/`
`acmt.csde.washington.edu:8000/acmt_shiny`

Note that both terminals have to be remained open for serving the app.

# Test shiny-server on acmt.csde.washington.edu
1. install shiny-server
2. In `etc/shiny-server/shiny-server.conf`, change `listen 3838` to `listen 8080` with `sudo vim etc/shiny-server/shiny-server.conf`.
3. Run `sudo shiny-server` in the terminal.
4. Try these websites:
`acmt.csde.washington.edu:8080`
`acmt.csde.washington.edu:8080/sample-apps/hello/`


# other commands
systemctl stop shiny-server

