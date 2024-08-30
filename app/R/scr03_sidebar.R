sidebar <- bslib::sidebar(
  shiny::helpText(em(
    "Use the following parameters to change the display of data in the plot."
  )),
  
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
    min = lubridate::today(tzone = "America/Phoenix") - lubridate::years(1),
    max = lubridate::today(tzone = "America/Phoenix") - 1,
    format = "MM d, yyyy",
    startview = "month",
    weekstart = 0, # Sunday
    width = "100%",
    autoclose = TRUE
  ),
  
  shiny::varSelectInput(
    "color_by", "Color by",
    penguins[c("species", "island", "sex")],
    selected = "species"
  ),
  
  width = 300,
  position = "left",
  open = list(desktop = "open", mobile = "always-above"),
  id = "sidebar",
  title = NULL,
  bg = "#E2E9EB",
  #bg = "#FFFFFF",
  fg = "#343a40",
  class = NULL,
  max_height_mobile = NULL,
  gap = NULL,
  padding = NULL
)
