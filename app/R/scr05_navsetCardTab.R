navsetCardTab <- bslib::navset_card_tab(
  id = "navsetCardTab",
  selected = "scatterplot",
  title = NULL,
  sidebar = NULL,
  header = NULL,
  footer = NULL,
  height = 600,
  full_screen = TRUE,
  #wrapper = card_body,
  
  bslib::nav_panel(
    title = "Scatterplot",
    value = "scatterplot",
    plotly::plotlyOutput("scatterplot")
  ),
  
  bslib::nav_panel(
    title = "Time Series",
    value = "timeSeries",
    plotly::plotlyOutput("timeSeries")
  )
) |>
  htmltools::tagAppendAttributes(
    #https://getbootstrap.com/docs/5.0/utilities/api/
    class = "border-0 rounded-0 shadow-none"
  )
