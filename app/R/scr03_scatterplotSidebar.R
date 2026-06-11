scatterplotSidebar <- 
  bslib::sidebar(
    width = 300,
    position = "left",
    open = list(desktop = "open", mobile = "always-above"),
    id = "scatterplotSidebar",
    title = NULL,
    bg = "#FFFFFF",
    fg = "#191919",
    class = NULL,
    max_height_mobile = NULL,
    gap = NULL,
    padding = NULL,
    
    bslib::accordion(
      id = "scatterplotAccordion",
      # open = NULL,
      # multiple = TRUE,
      class = NULL,
      width = "auto",
      height = "auto",
      
      # Visible elements
      
      htmltools::p(
        bsicons::bs_icon("sliders", class = "bolder-icon"), 
        htmltools::HTML("&nbsp;<strong>DATA DISPLAY</strong>&nbsp;"),
        bslib::tooltip(
          bsicons::bs_icon("info-circle"),
          "Specify a station to highlight, and battery and weather variables to show in the graph.",
          id = "infoDataDisplay",
          placement = "right"
        ),
        
        class = "data-display-title"
      ),
      
      shiny::selectInput(
        inputId = "azmetStationScatterplot", 
        label = "AZMet Station",
        choices = azmetStationMetadata$meta_station_name,
        # selected = azmetStationMetadata$meta_station_name[1]
        selected = NULL
      ),
        
      shiny::selectInput(
        inputId = "batteryVariableScatterplot", 
        label = "Battery Variable",
        choices = batteryVariables[order(batteryVariables$variable), ]$variable,
        selected = batteryVariables[order(batteryVariables$variable), ]$variable[1]
        # selected = NULL
      ),
        
      shiny::selectInput(
        inputId = "weatherVariableScatterplot", 
        label = "Weather Variable",
        choices = weatherVariables[order(weatherVariables$variable), ]$variable,
        selected = weatherVariables[order(weatherVariables$variable), ]$variable[1]
        # selected = NULL
      )
    ) # bslib::accordion()
  ) # bslib::sidebar()
