sidebar <- bslib::sidebar(
  width = 300,
  position = "left",
  open = list(desktop = "open", mobile = "always-above"),
  id = "sidebar",
  title = NULL,
  bg = "#FFFFFF",
  fg = "#000000",
  class = NULL,
  max_height_mobile = NULL,
  gap = NULL,
  padding = NULL,
  
  bslib::accordion(
    id = "accordion",
    open = "DATE SELECTION",
    multiple = TRUE,
    class = NULL,
    width = "auto",
    height = "auto",
    
    bslib::accordion_panel(
      title = "DATE SELECTION",
      value = "dateSelection",
      icon = bsicons::bs_icon("calendar-event"),
      
      shiny::helpText(em(
        "Set start and end dates of the period of interest. Then, click or tap 'RETRIEVE DATA'."
      )),
      
      htmltools::br(),
      
      shiny::dateInput(
        inputId = "startDate",
        label = "Start Date",
        value = initialSidebarStartDate,
        min = apiStartDate,
        max = lubridate::today(tzone = "America/Phoenix") - 1,
        format = "MM d, yyyy",
        startview = "month",
        weekstart = 0, # Sunday
        width = "100%",
        autoclose = TRUE
      ),
      
      shiny::dateInput(
        inputId = "endDate",
        label = "End Date",
        value = lubridate::today(tzone = "America/Phoenix") - 1,
        min = apiStartDate,
        max = lubridate::today(tzone = "America/Phoenix") - 1,
        format = "MM d, yyyy",
        startview = "month",
        weekstart = 0, # Sunday
        width = "100%",
        autoclose = TRUE
      ),
      
      htmltools::br(),
      
      shiny::actionButton(
        inputId = "retrieveData", 
        label = "RETRIEVE DATA",
        class = "btn btn-block btn-blue"
      ),
      
      htmltools::br()
    ),
    
    bslib::accordion_panel(
      title = "DATA DISPLAY",
      value = "dataDisplay",
      icon = bsicons::bs_icon("graph-up"),
      
      shiny::helpText(em(
        "Specify an AZMet station to highlight, and battery and weather variables to show in the graph."
      )),
      
      htmltools::br(),
      
      shiny::selectInput(
        inputId = "azmetStation", 
        label = "AZMet Station",
        choices = azmetStations[order(azmetStations$stationName), ]$stationName,
        selected = "Aguila"
      ),
      
      shiny::selectInput(
        inputId = "batteryVariable", 
        label = "Battery Variable",
        choices = batteryVariables[order(batteryVariables$variable), ]$variable,
        selected = batteryVariables[order(batteryVariables$variable), ]$variable[1]
      ),
      
      shiny::selectInput(
        inputId = "weatherVariable", 
        label = "Weather Variable",
        choices = weatherVariables[order(weatherVariables$variable), ]$variable,
        selected = weatherVariables[order(weatherVariables$variable), ]$variable[1]
      ),
      
      shiny::varSelectInput(
        "color_by", "Color by",
        penguins[c("species", "island", "sex")],
        selected = "species"
      )
    )
  ), # bslib::accordion()
) # bslib::sidebar()
