scatterplotSidebar <- 
  bslib::sidebar(
    width = 300,
    position = "left",
    open = NULL,
    id = "scatterplotSidebar",
    title = NULL,
    bg = "#FFFFFF",
    fg = "#191919",
    class = NULL,
    max_height_mobile = NULL,
    gap = NULL,
    padding = NULL,
    
    
    # Visible elements -----
    
    htmltools::p(
      bsicons::bs_icon("sliders", class = "bolder-icon"), 
      htmltools::HTML("&nbsp;<strong>DATA DISPLAY</strong>&nbsp;"),
      bslib::tooltip(
        bsicons::bs_icon("info-circle"),
        "Select a station to highlight, and battery and weather variables to show in the graph.",
        id = "infoDataDisplay",
        placement = "right"
      ),
      
      class = "data-display-title"
    ),
    
    shiny::selectInput(
      inputId = "azmetStationScatterplot", 
      label = "AZMet Station",
      # choices = c("Select a station..." = "", sort(azmetStationMetadata$meta_station_name)),
      choices = NULL,
      selected = NULL
    ),
    
    shiny::selectInput(
      inputId = "batteryVariableScatterplot", 
      label = "Battery Variable",
      choices = c("Select a variable..." = "", sort(batteryVariables$variable)),
      selected = NULL
    ),
    
    shiny::selectInput(
      inputId = "weatherVariableScatterplot", 
      label = "Weather Variable",
      choices = c("Select a variable..." = "", sort(weatherVariables$variable)),
      selected = NULL
    )
  ) # bslib::sidebar()
