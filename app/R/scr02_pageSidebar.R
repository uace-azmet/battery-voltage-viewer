pageSidebar <- 
  bslib::sidebar(
    width = 300,
    position = "left",
    open = list(desktop = "open", mobile = "always-above"),
    id = "sidebar",
    title = NULL,
    bg = "#FFFFFF",
    fg = "#191919",
    class = NULL,
    max_height_mobile = NULL,
    gap = NULL,
    padding = NULL,
    
    bslib::accordion(
      id = "pageAccordion",
      # open = NULL,
      # multiple = TRUE,
      class = NULL,
      width = "auto",
      height = "auto",
      
      # Visible elements
      
      htmltools::p(
        htmltools::HTML(
          paste0(
            bsicons::bs_icon("calendar-event", class = "bolder-icon"), 
            htmltools::HTML("&nbsp;&nbsp;&nbsp;<strong>DATE SELECTION</strong>&nbsp;"),
            bslib::tooltip(
              bsicons::bs_icon("info-circle"),
              "Set start and end dates of the period of interest. Then, click or tap 'RETRIEVE DATA'.",
              id = "infoDateSelection",
              placement = "right"
            )
          )
        ),
        
        class = "date-selection-title"
      ),
      
      shiny::dateInput(
        inputId = "startDate",
        label = "Start Date",
        value = lubridate::today(tzone = "America/Phoenix") - lubridate::dmonths(x = 3),
        min = batVoltStartDate,
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
        min = batVoltStartDate,
        max = lubridate::today(tzone = "America/Phoenix") - 1,
        format = "MM d, yyyy",
        startview = "month",
        weekstart = 0, # Sunday
        width = "100%",
        autoclose = TRUE
      ),
      
      shiny::actionButton(
        inputId = "retrieveData", 
        label = "RETRIEVE DATA",
        class = "btn btn-block btn-blue"
      )
    ) # bslib::accordion()
  ) # bslib::sidebar()
