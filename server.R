users <- reactiveValues(number_of_user_simutaneous = 0)

server <- function(input, output) {
  if (!interactive()) sink(stderr(), type = "output")  # print standard output to the log file; otherwise log file only shows stderr
      #' Count online users
  onSessionStart <- isolate({
    users$number_of_user_simutaneous <- users$number_of_user_simutaneous + 1
  })
  onSessionEnded(function() {
    isolate({
      users$number_of_user_simutaneous <- users$number_of_user_simutaneous - 1
    })
  })
  output$acmt_user_simutaneous <- renderText({
    return(paste("Number of online users: ", users$number_of_user_simutaneous))
  })

        #' Geocoder
  geocoder_input_data <- reactiveValues(acmt_geocoder_do_convertion = NULL)
  observeEvent(eventExpr = input$acmt_geocoder_do_convertion, {
    geocoder_input_data$acmt_geocoder_do_convertion <- input$acmt_geocoder_do_convertion
    geocoder_input_data$acmt_geocoder_address <- input$acmt_geocoder_address
  })
  latitude_and_longitude_list <- eventReactive(eventExpr = input$acmt_geocoder_do_convertion, {
    get_latitude_and_longitude_from_address_with_osm(input_address = input$acmt_geocoder_address)
  })

  output$acmt_geocoder_latitude <- renderText({
    return(as.character(latitude_and_longitude_list()$latitude))
  })
  output$acmt_geocoder_longitude <- renderText({
    return(as.character(latitude_and_longitude_list()$longitude))
  })
  output$acmt_geocoder_code <- renderText({
    if (is.null(geocoder_input_data$acmt_geocoder_do_convertion)) {  # the app just started, show nothing
      return(NULL)
    }
    return(paste("geocode(", "\"", geocoder_input_data$acmt_geocoder_address, "\"", ")", sep = ""))
  })

            #' Plot area of interest
  buffer_plotting_input_data <- reactiveValues(plot_circular = NULL, plot_travelable = NULL)
  observeEvent(eventExpr = input$acmt_buffer_circular_do_plot, {
    buffer_plotting_input_data$plot_circular <- TRUE
    buffer_plotting_input_data$plot_travelable <- FALSE

    buffer_plotting_input_data$latitude <- as.numeric(input$acmt_buffer_latitude)
    buffer_plotting_input_data$longitude <- as.numeric(input$acmt_buffer_longitude)
    buffer_plotting_input_data$acmt_buffer_circular_radius <- as.numeric(input$acmt_buffer_circular_radius)
  })
  observeEvent(eventExpr = input$acmt_buffer_travelable_do_plot, {
    buffer_plotting_input_data$plot_circular <- FALSE
    buffer_plotting_input_data$plot_travelable <- TRUE

    buffer_plotting_input_data$latitude <- as.numeric(input$acmt_buffer_latitude)
    buffer_plotting_input_data$longitude <- as.numeric(input$acmt_buffer_longitude)
    buffer_plotting_input_data$acmt_buffer_travelable_transportation_type <- input$acmt_buffer_travelable_transportation_type
    buffer_plotting_input_data$acmt_buffer_travelable_transportation_duration <- as.numeric(input$acmt_buffer_travelable_transportation_duration)
  })

  output$acmt_buffer_plot <- renderLeaflet({
    if (is.null(buffer_plotting_input_data$plot_circular) && is.null(buffer_plotting_input_data$plot_travelable)) {
      return()  # when the app first starts, do nothing until the plot button is clicked.
    }

    area_buffer <- NULL
    plot_circular <- buffer_plotting_input_data$plot_circular
    plot_travelable <- buffer_plotting_input_data$plot_travelable

    latitude <- buffer_plotting_input_data$latitude
    longitude <- buffer_plotting_input_data$longitude

    if (plot_circular) {
      area_buffer <- get_point_buffer_for_lat_long(long = longitude, lat = latitude, radius_meters = buffer_plotting_input_data$acmt_buffer_circular_radius)
    } else if (plot_travelable) {
      area_buffer <- get_travelable_buffer(latitude = latitude, longitude = longitude, travel_type = buffer_plotting_input_data$acmt_buffer_travelable_transportation_type, travel_time = buffer_plotting_input_data$acmt_buffer_travelable_transportation_duration)
    } else {
      stop("Error in plotting circular or travelable area")
    }

    plot <- plot_buffer_with_background(buffer = area_buffer, longitude = longitude, latitude = latitude)
    return(plot)
  })
  output$acmt_buffer_code <- renderText({
    if (is.null(buffer_plotting_input_data$plot_circular) && is.null(buffer_plotting_input_data$plot_travelable)) { # first time starting the app
      return()
    }

    code_get_buffer <- NULL
    code_print_buffer <- NULL

    plot_circular <- buffer_plotting_input_data$plot_circular
    plot_travelable <- buffer_plotting_input_data$plot_travelable
    latitude <- buffer_plotting_input_data$latitude
    longitude <- buffer_plotting_input_data$longitude

    if (plot_circular) {
      code_get_buffer <- paste0("area_buffer <- get_point_buffer_for_lat_long(long = ", longitude, ", lat = ", latitude, ", radius_meters = ", buffer_plotting_input_data$acmt_buffer_circular_radius, ")")
    } else if (plot_travelable) {
      code_get_buffer <- paste0("area_buffer <- get_travelable_buffer(latitude = ", latitude, ", longitude = ", longitude, ", travel_type = ", buffer_plotting_input_data$acmt_buffer_travelable_transportation_type, ", travel_time = ", buffer_plotting_input_data$acmt_buffer_travelable_transportation_duration, ")")
    } else {
      stop("Error in generating code for getting circular or travelable area buffer")
    }

    code_print_buffer <- paste0("plot_buffer_with_background(buffer = area_buffer, longitude = ", longitude, ", latitude = ", latitude, ")")
    return(paste(code_get_buffer, code_print_buffer, sep = "\n"))
  })

          #' Area interpolation
  area_interpolation_input_data <- reactiveValues(acmt_interpolation_do_interpolation = NULL)
  observeEvent(eventExpr = input$acmt_interpolation_do_interpolation, {
    area_interpolation_input_data$acmt_interpolation_do_interpolation <- input$acmt_interpolation_do_interpolation
    area_interpolation_input_data$acmt_interpolation_latitude <- as.numeric(input$acmt_interpolation_latitude)
    area_interpolation_input_data$acmt_interpolation_longitude <- as.numeric(input$acmt_interpolation_longitude)
    area_interpolation_input_data$acmt_interpolation_radius <- as.numeric(input$acmt_interpolation_radius)
    area_interpolation_input_data$acmt_interpolation_dataset <- input$acmt_interpolation_dataset
  })

  output$acmt_interpolation_table <- renderTable({
    if (is.null(area_interpolation_input_data$acmt_interpolation_do_interpolation)) {
      return()
    }
    table <- NULL
    acmt_shiny_path <- getwd()
    setwd(acmt_network_path)
    if (area_interpolation_input_data$acmt_interpolation_dataset == "American Community Survey(ACS)") {
      table <- get_acmt_standard_array(lat = area_interpolation_input_data$acmt_interpolation_latitude, long = area_interpolation_input_data$acmt_interpolation_longitude, radius_meters = area_interpolation_input_data$acmt_interpolation_radius, codes_of_acs_variables_to_get = c("B01001_001", "B01001_002", "B01001_026", "B05012_002", "B05012_003", "B02001_002", "B02001_003", "B02001_004", "B02001_005", "B08006_003", "B08006_004", "B08006_008", "B08006_014", "B08006_015", "B15003_017", "B15003_022", "B15003_023", "B15003_024", "B15003_025"))
    } else if (area_interpolation_input_data$acmt_interpolation_dataset == "walkability") {
      table <- get_acmt_standard_array(lat = area_interpolation_input_data$acmt_interpolation_latitude, long = area_interpolation_input_data$acmt_interpolation_longitude, radius_meters = area_interpolation_input_data$acmt_interpolation_radius, external_data_name_to_info_list = list(walkability = external_data_presets_walkability), codes_of_acs_variables_to_get = "B01001_001")
    #} else if (area_interpolation_input_data$acmt_interpolation_dataset == "food access index") {
    #  table <- get_acmt_standard_array(lat = area_interpolation_input_data$acmt_interpolation_latitude, long = area_interpolation_input_data$acmt_interpolation_longitude, radius_meters = area_interpolation_input_data$acmt_interpolation_radius, external_data_name_to_info_list = list(a = external_data_presets_food_access), codes_of_acs_variables_to_get = "B01001_001")
    } else if (area_interpolation_input_data$acmt_interpolation_dataset == "NO2") {
      table <- get_acmt_standard_array(lat = area_interpolation_input_data$acmt_interpolation_latitude, long = area_interpolation_input_data$acmt_interpolation_longitude, radius_meters = area_interpolation_input_data$acmt_interpolation_radius, external_data_name_to_info_list = list(no2 = external_data_presets_no2), codes_of_acs_variables_to_get = "B01001_001")
    } else if (area_interpolation_input_data$acmt_interpolation_dataset == "O3") {
      table <- get_acmt_standard_array(lat = area_interpolation_input_data$acmt_interpolation_latitude, long = area_interpolation_input_data$acmt_interpolation_longitude, radius_meters = area_interpolation_input_data$acmt_interpolation_radius, external_data_name_to_info_list = list(o3 = external_data_presets_o3), codes_of_acs_variables_to_get = "B01001_001")
    } else if (area_interpolation_input_data$acmt_interpolation_dataset == "PM2.5") {
      table <- get_acmt_standard_array(lat = area_interpolation_input_data$acmt_interpolation_latitude, long = area_interpolation_input_data$acmt_interpolation_longitude, radius_meters = area_interpolation_input_data$acmt_interpolation_radius, external_data_name_to_info_list = list(pm25 = external_data_presets_pm25), codes_of_acs_variables_to_get = "B01001_001")
    } else {
      stop("Area interpolation: unexpected dataset selected")
    }
    setwd(acmt_shiny_path)
    return(table[2:nrow(table), ])  # HACK: exclude the first row because ACS was mandatory even when non-ACS dataset was selected
  })
  output$acmt_interpolation_code <- renderText({
    if (is.null(area_interpolation_input_data$acmt_interpolation_do_interpolation)) {
      return()
    }

    code_interpolation <- NULL
    if (area_interpolation_input_data$acmt_interpolation_dataset == "American Community Survey(ACS)") {
      code_interpolation <- paste0("get_acmt_standard_array(lat = ", area_interpolation_input_data$acmt_interpolation_latitude, ", long = ", area_interpolation_input_data$acmt_interpolation_longitude,", radius_meters = ", area_interpolation_input_data$acmt_interpolation_radius, ", codes_of_acs_variables_to_get = c(\"B01001_001\", \"B01001_002\", \"B01001_026\", \"B05012_002\", \"B05012_003\", \"B02001_002\", \"B02001_003\", \"B02001_004\", \"B02001_005\", \"B08006_003\", \"B08006_004\", \"B08006_008\", \"B08006_014\", \"B08006_015\", \"B15003_017\", \"B15003_022\", \"B15003_023\", \"B15003_024\", \"B15003_025\"))[2:nrow(table), ]")
    } else if (area_interpolation_input_data$acmt_interpolation_dataset == "walkability") {
      code_interpolation <- paste0("get_acmt_standard_array(lat = ", area_interpolation_input_data$acmt_interpolation_latitude, ", long = ", area_interpolation_input_data$acmt_interpolation_longitude, ", radius_meters = ", area_interpolation_input_data$acmt_interpolation_radius, ", external_data_name_to_info_list = list(walkability = external_data_presets_walkability), codes_of_acs_variables_to_get = \"B01001_001\")[2:nrow(table), ]")
    } else if (area_interpolation_input_data$acmt_interpolation_dataset == "NO2") {
      code_interpolation <- paste0("get_acmt_standard_array(lat = ", area_interpolation_input_data$acmt_interpolation_latitude, ", long = ", area_interpolation_input_data$acmt_interpolation_longitude, ", radius_meters = area_interpolation_input_data$acmt_interpolation_radius, external_data_name_to_info_list = list(no2 = external_data_presets_no2), codes_of_acs_variables_to_get = \"B01001_001\")[2:nrow(table), ])")
    } else if (area_interpolation_input_data$acmt_interpolation_dataset == "O3") {
      code_interpolation <- paste0("get_acmt_standard_array(lat = ", area_interpolation_input_data$acmt_interpolation_latitude, ", long = ", area_interpolation_input_data$acmt_interpolation_longitude, ", radius_meters = ,", area_interpolation_input_data$acmt_interpolation_radius, ", external_data_name_to_info_list = list(o3 = external_data_presets_o3), codes_of_acs_variables_to_get = \"B01001_001\")[2:nrow(table), ])")
    } else if (area_interpolation_input_data$acmt_interpolation_dataset == "PM2.5") {
      code_interpolation <- paste0("get_acmt_standard_array(lat = ", area_interpolation_input_data$acmt_interpolation_latitude, ", long = ", area_interpolation_input_data$acmt_interpolation_longitude, ", radius_meters = ", area_interpolation_input_data$acmt_interpolation_radius, ", external_data_name_to_info_list = list(pm25 = external_data_presets_pm25), codes_of_acs_variables_to_get = \"B01001_001\")[2:nrow(table), ])")
    } else {
      stop("Generating code for area interpolation: unexpected dataset selected")
    }
    return(code_interpolation)
  })

          #' Incidence aggregation
  incidence_aggregation_input_data <- reactiveValues(acmt_interpolation_do_aggregation = NULL)
  observeEvent(eventExpr = input$acmt_aggregation_do_aggregation, {
    incidence_aggregation_input_data$acmt_aggregation_do_aggregation <- input$acmt_aggregation_do_aggregation
    incidence_aggregation_input_data$acmt_aggregation_latitude <- as.numeric(input$acmt_aggregation_latitude)
    incidence_aggregation_input_data$acmt_aggregation_longitude <- as.numeric(input$acmt_aggregation_longitude)
    incidence_aggregation_input_data$acmt_aggregation_radius <- as.numeric(input$acmt_aggregation_radius)
    incidence_aggregation_input_data$acmt_aggregation_dataset <- input$acmt_aggregation_dataset
  })

  output$acmt_aggregation_table <- renderTable({
    if (is.null(incidence_aggregation_input_data$acmt_aggregation_do_aggregation)) {
      return()
    }
    external_data_name_to_info_list <- NULL
    if (incidence_aggregation_input_data$acmt_aggregation_dataset == "911 calls") {
      external_data_name_to_info_list <- list(call911=external_data_presets_call911)
    } else if (incidence_aggregation_input_data$acmt_aggregation_dataset == "Seattle crime") {
      external_data_name_to_info_list <- list(crime_seattle=external_data_presets_crime_seattle)
    } else if (incidence_aggregation_input_data$acmt_aggregation_dataset == "Boston crime") {
      external_data_name_to_info_list <- list(crime_boston=external_data_presets_crime_boston)
    } else if (incidence_aggregation_input_data$acmt_aggregation_dataset == "Chicago crime") {
      external_data_name_to_info_list <- list(crime_chicago=external_data_presets_crime_chicago)
    } else if (incidence_aggregation_input_data$acmt_aggregation_dataset == "Los Angeles crime") {
      external_data_name_to_info_list <- list(crime_los_angeles=external_data_presets_crime_los_angeles)
    } else if (incidence_aggregation_input_data$acmt_aggregation_dataset == "Airbnb") {
      external_data_name_to_info_list <- list(crime_airbnb=external_data_presets_airbnb)
    } else {
      stop("Incidence aggregation: unexpected dataset selected")
    }
    acmt_shiny_path <- getwd()
    setwd(acmt_network_path)
    table <- get_aggregated_point_measures(latitude=incidence_aggregation_input_data$acmt_aggregation_latitude, longitude=incidence_aggregation_input_data$acmt_aggregation_longitude, radius=incidence_aggregation_input_data$acmt_aggregation_radius, external_data_name_to_info_list=external_data_name_to_info_list)$aggregated_result
    setwd(acmt_shiny_path)
    return(table[2:nrow(table), ])  # HACK: exclude the first row because ACS was mandatory even when non-ACS dataset was selected
  })
  output$acmt_aggregation_code <- renderText({
    if (is.null(incidence_aggregation_input_data$acmt_aggregation_do_aggregation)) {
      return()
    }
    code_get_info_list <- NULL
    if (incidence_aggregation_input_data$acmt_aggregation_dataset == "911 calls") {
      code_get_info_list <- "external_data_name_to_info_list <- list(call911=external_data_presets_call911)"
    } else if (incidence_aggregation_input_data$acmt_aggregation_dataset == "Seattle crime") {
      code_get_info_list <- "external_data_name_to_info_list <- list(crime_seattle=external_data_presets_crime_seattle)"
    } else if (incidence_aggregation_input_data$acmt_aggregation_dataset == "Boston crime") {
      code_get_info_list <- "external_data_name_to_info_list <- list(crime_boston=external_data_presets_crime_boston)"
    } else if (incidence_aggregation_input_data$acmt_aggregation_dataset == "Chicago crime") {
      code_get_info_list <- "external_data_name_to_info_list <- list(crime_chicago=external_data_presets_crime_chicago)"
    } else if (incidence_aggregation_input_data$acmt_aggregation_dataset == "Los Angeles crime") {
      code_get_info_list <- "external_data_name_to_info_list <- list(crime_los_angeles=external_data_presets_crime_los_angeles)"
    } else if (incidence_aggregation_input_data$acmt_aggregation_dataset == "Airbnb") {
      code_get_info_list <- "external_data_name_to_info_list <- list(crime_airbnb=external_data_presets_airbnb)"
    } else {
      stop("Incidence aggregation: unexpected dataset selected")
    }
    code_get_aggregated_point_measures <- paste0("get_aggregated_point_measures(latitude=", incidence_aggregation_input_data$acmt_aggregation_latitude, ", longitude=", incidence_aggregation_input_data$acmt_aggregation_longitude, ", radius=", incidence_aggregation_input_data$acmt_aggregation_radius, ", external_data_name_to_info_list=external_data_name_to_info_list)$aggregated_result[2:nrow(table), ]")
    return(paste(code_get_info_list, code_get_aggregated_point_measures, sep = "\n"))
  })
}