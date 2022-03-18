# adapted from http://shiny.rstudio-staging.com/gallery/shiny-theme-selector.html
ui <- navbarPage(
  theme = shinytheme("cosmo"),
  title = "ACMT",

  #' Geocoder
  tabPanel(title = "Geocoder",
           sidebarPanel(
             textInput(inputId = "acmt_geocoder_address", label = "Address", value = "4063 Spokane Ln, Seattle, WA 98105"),
             actionButton(inputId = "acmt_geocoder_do_convertion", label = "Convert"),
             h5(),
             textOutput(outputId = "acmt_user_simutaneous"),  # know bug: keep refreshing the page will increase the number of users, just wait for a momment and it will be back to the normal state
           ),
           mainPanel(
             conditionalPanel(condition="$('html').hasClass('shiny-busy')", tags$div("Loading...",id="loadmessage")),
             h4("Latitude"),
             verbatimTextOutput(outputId = "acmt_geocoder_latitude"),
             h4("Longitude"),
             verbatimTextOutput(outputId = "acmt_geocoder_longitude"),
             h4("ACMT code to reproduce"),
             verbatimTextOutput(outputId = "acmt_geocoder_code"),
           ),
  ),

  #' Plot area of interest
  tabPanel(title = "Plot area of interest",
           sidebarPanel(
             textInput(inputId = "acmt_buffer_latitude", label = "Latitude", value = "47.6578551"),
             textInput(inputId = "acmt_buffer_longitude", label = "Longitude", value = "-122.3107948"),
             tabsetPanel(type = "pills",
                         tabPanel(title = "Circular area",
                                  #textInput(inputId = "acmt_buffer_circular_radius", label = "Radius (meters)", value = "200"),
                                  sliderInput(inputId = "acmt_buffer_circular_radius", label = "Radius (meters)", min = 1, max = 500, value = 200),
                                  actionButton(inputId = "acmt_buffer_circular_do_plot", label = "Plot")
                         ),
                         tabPanel("Travelable area",
                                  selectInput(inputId = "acmt_buffer_travelable_transportation_type", label = "Transportation type", choices = c("foot", "bike", "car")),
                                  #textInput(inputId = "acmt_buffer_travelable_transportation_duration", label = "Duration (minutes)", value = "10"),
                                  sliderInput(inputId = "acmt_buffer_travelable_transportation_duration", label = "Duration (minutes)", min = 1, max = 20, value = 10),
                                  actionButton(inputId = "acmt_buffer_travelable_do_plot", label = "Plot")
                         )
             )
           ),
           mainPanel(
             conditionalPanel(condition="$('html').hasClass('shiny-busy')", tags$div("Loading...",id="loadmessage")),
             h4("Showing the area of interest on map"),
             leafletOutput(outputId = "acmt_buffer_plot"),
             h4("ACMT code to reproduce"),
             verbatimTextOutput(outputId = "acmt_buffer_code"),
           )
  ),

  #' Area interpolation
  tabPanel(title = "Area interpolation",
           sidebarPanel(
             textInput(inputId = "acmt_interpolation_latitude", label = "Latitude", value = "47.6578551"),
             textInput(inputId = "acmt_interpolation_longitude", label = "Longitude", value = "-122.3107948"),
             #textInput(inputId = "acmt_interpolation_radius", label = "Radius (meters)", value = "200"),
             sliderInput(inputId = "acmt_interpolation_radius", label = "Radius (meters)", min = 1, max = 500, value = 200),
             selectInput(inputId = "acmt_interpolation_dataset", label = "Dataset", choices = c("American Community Survey(ACS)", "walkability", "NO2", "O3", "PM2.5")),
             actionButton(inputId = "acmt_interpolation_do_interpolation", label = "Get area-interpolated measures")
           ),
           mainPanel(
             conditionalPanel(condition="$('html').hasClass('shiny-busy')", tags$div("Loading...",id="loadmessage")),
             h4("Showing the interpolated measures in a table"),
             tableOutput(outputId = "acmt_interpolation_table"),
             h4("ACMT code to reproduce"),
             verbatimTextOutput(outputId = "acmt_interpolation_code"),
           )
  ),

  #' Incidence aggregation
  tabPanel(title = "Incidence aggregation",
           sidebarPanel(
             textInput(inputId = "acmt_aggregation_latitude", label = "Latitude", value = "47.6578551"),
             textInput(inputId = "acmt_aggregation_longitude", label = "Longitude", value = "-122.3107948"),
             #textInput(inputId = "acmt_aggregation_radius", label = "Radius (meters)", value = "200"),
             sliderInput(inputId = "acmt_aggregation_radius", label = "Radius (meters)", min = 1, max = 500, value = 200),
             selectInput(inputId = "acmt_aggregation_dataset", label = "Dataset", choices = c("911 calls", "Seattle crime", "Boston crime", "Chicago crime", "Los Angeles crime", "Airbnb")),
             actionButton(inputId = "acmt_aggregation_do_aggregation", label = "Get aggregated measures")
           ),
           mainPanel(
             conditionalPanel(condition="$('html').hasClass('shiny-busy')", tags$div("Loading...",id="loadmessage")),
             h4("Showing the aggregated incidence in a table"),
             tableOutput(outputId = "acmt_aggregation_table"),
             h4("ACMT code to reproduce"),
             verbatimTextOutput(outputId = "acmt_aggregation_code"),
           )
  ),

  #' Documentation
  tabPanel(title = "Documentation",
           includeMarkdown("documentation.md"),
  )
  #tabPanel("Navbar 3", "This panel is intentionally left blank")
)