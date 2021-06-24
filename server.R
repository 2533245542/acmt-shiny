server <- function(input, output) {
    #' Geocoder
  latitude_and_longitude_list <- eventReactive(eventExpr = input$acmt_geocoder_do_convertion, ignoreNULL = FALSE, {
    get_latitude_and_longitude_from_address_with_osm(input_address = input$acmt_geocoder_address)
  })
  output$acmt_geocoder_latitude <- renderText({
    return(as.character(latitude_and_longitude_list()$latitude))
  })
  output$acmt_geocoder_longitude <- renderText({
    return(as.character(latitude_and_longitude_list()$longitude))
  })

    #' Plot area of interest
  plot_circular_or_travalable <- reactiveValues(plot_circular = FALSE, plot_travalable = FALSE)

  observeEvent(eventExpr = input$acmt_buffer_circular_do_plot, ignoreNULL = FALSE, {
    plot_circular_or_travalable$plot_circular <- TRUE
    plot_circular_or_travalable$plot_travelable <- FALSE

    plot_circular_or_travalable$latitude <- as.numeric(input$acmt_buffer_latitude)
    plot_circular_or_travalable$longitude <- as.numeric(input$acmt_buffer_longitude)
    plot_circular_or_travalable$acmt_buffer_circular_radius <- as.numeric(input$acmt_buffer_circular_radius)
  })
  observeEvent(eventExpr = input$acmt_buffer_travelable_do_plot, {
    plot_circular_or_travalable$plot_circular <- FALSE
    plot_circular_or_travalable$plot_travelable <- TRUE

    plot_circular_or_travalable$latitude <- as.numeric(input$acmt_buffer_latitude)
    plot_circular_or_travalable$longitude <- as.numeric(input$acmt_buffer_longitude)
    plot_circular_or_travalable$acmt_buffer_travelable_transportation_type <- input$acmt_buffer_travelable_transportation_type
    plot_circular_or_travalable$acmt_buffer_travelable_transportation_duration <- as.numeric(input$acmt_buffer_travelable_transportation_duration)
  })

  output$acmt_buffer_plot <- renderLeaflet({
    area_buffer <- NULL
    plot_circular <- plot_circular_or_travalable$plot_circular
    plot_travelable <- plot_circular_or_travalable$plot_travelable

    latitude <- plot_circular_or_travalable$latitude
    longitude <- plot_circular_or_travalable$longitude
    if (plot_circular) {
      area_buffer <- get_point_buffer_for_lat_long(long = longitude, lat = latitude, radius_meters = plot_circular_or_travalable$acmt_buffer_circular_radius)
    } else if (plot_travelable) {
      area_buffer <- get_travelable_buffer(latitude = latitude, longitude = longitude, travel_type = plot_circular_or_travalable$acmt_buffer_travelable_transportation_type, travel_time = plot_circular_or_travalable$acmt_buffer_travelable_transportation_duration)
    } else {
      stop("Error in plotting circular or travelable area")
    }

    plot <- plot_buffer_with_background(buffer = area_buffer, longitude = longitude, latitude = latitude)
    return(plot)
  })

    #' Area interpolation

    #' Incidence aggregation
}