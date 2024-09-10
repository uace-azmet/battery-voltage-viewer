navsetCardTab <- bslib::navset_card_tab(
  id = "navsetCardTab",
  selected = "billLength",
  title = NULL,
  sidebar = NULL,
  header = NULL,
  footer = NULL,
  height = 450,
  full_screen = TRUE,
  wrapper = card_body,
  
  bslib::nav_panel(
    title = "Scatterplot",
    value = "scatterplot",
    p("scatterplot")
  ),
  
  bslib::nav_panel(
    title = "Time Series",
    value = "timeSeries",
    p("time series")
  ),
  
  bslib::nav_panel(
    title = "Bill Length",
    value = "billLength",
    shiny::plotOutput("bill_length")
  ),
  
  bslib::nav_panel(
    title = "Bill Depth", 
    value = "billDepth",
    shiny::plotOutput("bill_depth")
  ),
  
  bslib::nav_panel(
    title = "Body Mass", 
    value = "bodyMass",
    shiny::plotOutput("body_mass")
  )
) |>
  htmltools::tagAppendAttributes(
    #https://getbootstrap.com/docs/5.0/utilities/api/
    class = "border-0 rounded-0 shadow-none"
  )
