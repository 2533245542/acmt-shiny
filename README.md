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
First run `acmt-network` with `docker-compose` in one terminal.

Then open another terminal, use `docker exec -it acmt-network_app_1 /bin/bash` to enter the `network_app_1` container.

In `srv/shiny-server/acmt_shiny/global.R`, set `acmt_network_path` to the correct one.

Run `shiny-server` in the terminal.

Try these websites:
`http://localhost:3838/`
`http://localhost:3838/sample-apps/hello/`

Note that both terminals have to be set to be open.