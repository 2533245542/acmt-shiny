server <- function(input, output) {
  output$acmt_geocoder_latitude <- renderText({
    as.character(47.6556209)
  })
  output$acmt_geocoder_longitude <- renderText({
    as.character(-122.3074085)
  })
}