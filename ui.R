# adapted from http://shiny.rstudio-staging.com/gallery/shiny-theme-selector.html
ui <- navbarPage(
  theme = shinytheme("cosmo"),
  title = "ACMT",
  tabPanel(title = "Geocoder",
           sidebarPanel(
             textInput(inputId = "acmt_geocoder_address", label = "Address", value = "4063 Spokane Ln, Seattle, WA 98105"),
             actionButton(inputId = "acmt_geocoder_do_convertion", label = "Convert")
           ),
           mainPanel(
             h4("Latitude"),
             verbatimTextOutput(outputId = "acmt_geocoder_latitude"),
             h4("Longitude"),
             verbatimTextOutput(outputId = "acmt_geocoder_longitude")
           )
  ),

  tabPanel(title = "Plot area of interest",
           sidebarPanel(
             textInput(inputId = "acmt_buffer_latitude", label = "Latitude", value = "30.211"),
             textInput(inputId = "acmt_buffer_longitude", label = "Longitude", value = "-122.211"),
             tabsetPanel(type = "pills",
                         tabPanel(title = "Circular area",
                                  textInput(inputId = "acmt_buffer_circular_radius", label = "Radius (meters)", value = "200"),
                                  actionButton(inputId = "acmt_buffer_circular_do_plot", label = "Plot")
                         ),
                         tabPanel("Travelable area",
                                  selectInput(inputId = "acmt_buffer_travelable_transportation_type", label = "Transportation type", choices = c("Walk", "Bike", "Car")),
                                  textInput(inputId = "acmt_buffer_circular_radius", label = "Radius (meters)", value = "200"),
                                  actionButton(inputId = "acmt_buffer_travelable_do_plot", label = "Plot")
                         )
             )
           ),
           mainPanel(
             h4("Showing the area of intereset on map")
           )
  ),
  tabPanel(title = "Area interpolation",
           sidebarPanel(
             textInput(inputId = "acmt_interpolation_latitude", label = "Latitude", value = "30.211"),
             textInput(inputId = "acmt_interpolation_longitude", label = "Longitude", value = "-122.211"),
             textInput(inputId = "acmt_interpolation_radius", label = "Radius (meters)", value = "200"),
             selectInput(inputId = "acmt_interpolation_dataset", label = "Datset", choices = c("ACS", "PM2.5", "Crime")),
             actionButton(inputId = "acmt_interpolation_do_interpolation", label = "Get area-interpolated measures")
           ),
           mainPanel(
             h4("Showing the interpolated measures in a table")
           )
  ),


  tabPanel(title = "Documentation",
           h4("Documentation: https://docs.google.com/document/d/18Sii8PldC54C8CERQISAp-jB3ucqhi_GnxlJ7jyaP9U/edit#"),
           h4("In the local version of ACMT, getting travelable buffer sends requests to OpenStreenMap and is thus not private."),
           h4("Other functinos of the local ACMT are able to preserve privacy.")
  )
  #tabPanel("Navbar 3", "This panel is intentionally left blank")
)