# Shiny app to explore plots of battery voltage with solar radiation and temperature by AZMet station

# Add code for the following
# 
# 'azmet-shiny-template.html': <!-- Google tag (gtag.js) -->


# Libraries
#library(azmetr)
library(bslib)
library(dplyr)
library(ggplot2)
library(htmltools)
library(lubridate)
library(shiny)
library(tibble)
library(vroom)

# Functions
#source("./R/fxnABC.R", local = TRUE)

# Scripts
#source("./R/scr##DEF.R", local = TRUE)

data(penguins, package = "palmerpenguins")

sidebar <- bslib::sidebar(
  bslib::accordion(
    bslib::accordion_panel(
      title = "DATE SELECTION",
      
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
      )
    ),
    
    bslib::accordion_panel(
      title = "DATA DISPLAY",
      
      shiny::helpText(em(
        "Use these parameters to change the display of data in the plot."
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
      
      shiny::varSelectInput(
        "color_by", "Color by",
        penguins[c("species", "island", "sex")],
        selected = "species"
      )
    )
  ), #bslib::accordion()
  
  width = 300,
  position = "left",
  open = list(desktop = "open", mobile = "always-above"),
  id = "sidebar",
  title = NULL,
  bg = "#E2E9EB",
  #bg = "#FFFFFF",
  fg = "#262626",
  class = NULL,
  max_height_mobile = NULL,
  gap = NULL,
  padding = NULL
)

cards <- list(
  card(
    full_screen = TRUE,
    card_header("Bill Length"),
    bslib::layout_sidebar(
      fillable = TRUE,
      shiny::varSelectInput(
        "color_by", "Color by",
        penguins[c("species", "island", "sex")],
        selected = "species"
      )
    ),
    plotOutput("bill_length")
  ),
  card(
    full_screen = TRUE,
    card_header("Bill depth"),
    plotOutput("bill_depth")
  ),
  card(
    full_screen = TRUE,
    card_header("Body Mass"),
    plotOutput("body_mass")
  )
)


# UI --------------------

ui <- htmltools::htmlTemplate(
  
  filename = "azmet-shiny-template.html",
  
  pageSidebar = bslib::page_sidebar(
    title = NULL,
    sidebar = sidebar,
    
    bslib::navset_card_tab(
      nav_panel("Bill Length", plotOutput("bill_length")),
      nav_panel("Bill Depth", plotOutput("bill_depth")),
      nav_panel("Body Mass", plotOutput("body_mass"))
    ),
    
    fillable = TRUE,
    fillable_mobile = FALSE,
    theme = theme,
    lang = NULL,
    window_title = NA
  ) # bslib::page_sidebar()
) # htmltools::htmlTemplate()


# Server --------------------

server <- function(input, output, session) {
  
  # Reactive events -----
  
  # Outputs -----
  
  gg_plot <- reactive({
    ggplot(penguins) +
      geom_density(aes(fill = !!input$color_by), alpha = 0.2) +
      theme_bw(base_size = 16) +
      theme(axis.title = element_blank())
  })
  
  output$bill_length <- renderPlot(gg_plot() + aes(bill_length_mm))
  output$bill_depth <- renderPlot(gg_plot() + aes(bill_depth_mm))
  output$body_mass <- renderPlot(gg_plot() + aes(body_mass_g))
}

# Run --------------------

shinyApp(ui = ui, server = server)
