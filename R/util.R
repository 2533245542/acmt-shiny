#' Get the latitude and longitude from a address using OpenStreetMap.
#'
get_latitude_and_longitude_from_address_with_osm <- function (input_address) {
  some_addresses <- tribble(
    ~name,                  ~addr,
    "Input address",         input_address
  )
  lat_longs <- some_addresses %>%
    tidygeocoder::geocode(addr, method = 'osm', lat = latitude , long = longitude)
  return(list(latitude=lat_longs$latitude, longitude=lat_longs$longitude))
}

#' Load ACMT functions given the directory to where setup-acmt.R locates.
#'
load_acmt_functions <- function (acmt_network_path) {
  set_up_file_path <- file.path(acmt_network_path, "setup-acmt.R")
  source(set_up_file_path, chdir = TRUE)  # change working directory to acmt_network_path when running source
}

