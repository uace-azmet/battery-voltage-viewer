navsetCardTab <- bslib::navset_card_tab(
  id = "navsetCardTab",
  selected = "scatterplot",
  title = NULL,
  sidebar = NULL,
  header = NULL,
  footer = NULL,
  height = 700,
  full_screen = TRUE,
  #wrapper = card_body,
  
  bslib::nav_panel(
    title = "Scatterplot",
    value = "scatterplot",
    
    bslib::layout_sidebar(
      sidebar = sidebarScatterplot, # `scr##_sidebarScatterplot.R`
      shiny::htmlOutput(outputId = "scatterplotTitle"),
      plotly::plotlyOutput("scatterplot") 
    )
  ),
  
  bslib::nav_panel(
    title = "Time Series",
    value = "timeSeries",
    
    bslib::layout_sidebar(
      sidebar = sidebarTimeSeries, # `scr##_sidebarTimeSeries.R`
      shiny::htmlOutput(outputId = "timeSeriesTitle"),
      plotly::plotlyOutput("timeSeries") 
    )
  )
) |>
  htmltools::tagAppendAttributes(
    #https://getbootstrap.com/docs/5.0/utilities/api/
    class = "border-0 rounded-0 shadow-none"
  )
