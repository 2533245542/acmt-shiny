# adapted from http://shiny.rstudio-staging.com/gallery/shiny-theme-selector.html
ui <- navbarPage(
  theme = shinytheme("cosmo"),
  title = "ACMT",

  #' Geocoder
  tabPanel(title = "Geocoder",
           sidebarPanel(
             textInput(inputId = "acmt_geocoder_address", label = "Address", value = "4063 Spokane Ln, Seattle, WA 98105"),
             actionButton(inputId = "acmt_geocoder_do_convertion", label = "Convert")
           ),
           mainPanel(
             conditionalPanel(condition="$('html').hasClass('shiny-busy')", tags$div("Loading...",id="loadmessage")),
             h4("Latitude"),
             verbatimTextOutput(outputId = "acmt_geocoder_latitude"),
             h4("Longitude"),
             verbatimTextOutput(outputId = "acmt_geocoder_longitude")
           ),
  ),

  #' Plot area of interest
  tabPanel(title = "Plot area of interest",
           sidebarPanel(
             textInput(inputId = "acmt_buffer_latitude", label = "Latitude", value = "47.6578551"),
             textInput(inputId = "acmt_buffer_longitude", label = "Longitude", value = "-122.3107948"),
             tabsetPanel(type = "pills",
                         tabPanel(title = "Circular area",
                                  textInput(inputId = "acmt_buffer_circular_radius", label = "Radius (meters)", value = "200"),
                                  actionButton(inputId = "acmt_buffer_circular_do_plot", label = "Plot")
                         ),
                         tabPanel("Travelable area",
                                  selectInput(inputId = "acmt_buffer_travelable_transportation_type", label = "Transportation type", choices = c("foot", "bike", "car")),
                                  textInput(inputId = "acmt_buffer_travelable_transportation_duration", label = "Duration (minutes)", value = "10"),
                                  actionButton(inputId = "acmt_buffer_travelable_do_plot", label = "Plot")
                         )
             )
           ),
           mainPanel(
             conditionalPanel(condition="$('html').hasClass('shiny-busy')", tags$div("Loading...",id="loadmessage")),
             h4("Showing the area of interest on map"),
             leafletOutput(outputId = "acmt_buffer_plot")
           )
  ),

  #' Area interpolation
  tabPanel(title = "Area interpolation",
           sidebarPanel(
             textInput(inputId = "acmt_interpolation_latitude", label = "Latitude", value = "47.6578551"),
             textInput(inputId = "acmt_interpolation_longitude", label = "Longitude", value = "-122.3107948"),
             textInput(inputId = "acmt_interpolation_radius", label = "Radius (meters)", value = "200"),
             selectInput(inputId = "acmt_interpolation_dataset", label = "Datset", choices = c("American Community Survey(ACS)", "walkability", "NO2", "O3", "PM2.5")),
             actionButton(inputId = "acmt_interpolation_do_interpolation", label = "Get area-interpolated measures")
           ),
           mainPanel(
             conditionalPanel(condition="$('html').hasClass('shiny-busy')", tags$div("Loading...",id="loadmessage")),
             h4("Showing the interpolated measures in a table"),
             dataTableOutput(outputId = "acmt_interpolation_table")
           )
  ),

  #' Incidence aggregation
  tabPanel(title = "Incidence aggregation",
           sidebarPanel(
             textInput(inputId = "acmt_aggregation_latitude", label = "Latitude", value = "47.6578551"),
             textInput(inputId = "acmt_aggregation_longitude", label = "Longitude", value = "-122.3107948"),
             textInput(inputId = "acmt_aggregation_radius", label = "Radius (meters)", value = "200"),
             selectInput(inputId = "acmt_aggregation_dataset", label = "Datset", choices = c("911 calls", "Seattle crime", "Boston crime", "Chicago crime", "Los Angeles crime", "Airbnb")),
             actionButton(inputId = "acmt_aggregation_do_aggregation", label = "Get aggregated measures")
           ),
           mainPanel(
             conditionalPanel(condition="$('html').hasClass('shiny-busy')", tags$div("Loading...",id="loadmessage")),
             h4("Showing the aggregated incidence in a table"),
             dataTableOutput(outputId = "acmt_aggregation_table")
           )
  ),

  #' Documentation
  tabPanel(title = "Documentation",
           h4("Documentation: https://docs.google.com/document/d/18Sii8PldC54C8CERQISAp-jB3ucqhi_GnxlJ7jyaP9U/edit#"),
           h4("In the local version of ACMT, getting travelable buffer sends requests to OpenStreenMap and is thus not private."),
           h4("Other functinos of the local ACMT are able to preserve privacy.")
  )
  #tabPanel("Navbar 3", "This panel is intentionally left blank")
)