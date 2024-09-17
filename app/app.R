# Shiny app to explore graphs that compare battery voltage with weather variables by AZMet station

# Add code for the following
# 
# 'azmet-shiny-template.html': <!-- Google tag (gtag.js) -->


# Libraries
library(azmetr)
library(bslib)
library(dplyr)
library(ggplot2)
library(htmltools)
library(lubridate)
library(magrittr)
library(plotly)
library(shiny)
library(tibble)
library(vroom)

# Functions
#source("./R/fxnABC.R", local = TRUE)

# Scripts
#source("./R/scr##DEF.R", local = TRUE)


# UI --------------------

ui <- htmltools::htmlTemplate(
  
  filename = "azmet-shiny-template.html",
  
  pageSidebar = bslib::page_sidebar(
    title = NULL,
    
    # `scr04_sidebar`
    sidebar = sidebar,
    
    # `scr05_navsetCardTab.R`
    navsetCardTab,
    
    fillable = TRUE,
    fillable_mobile = FALSE,
    theme = theme,
    lang = NULL,
    window_title = NA
  )
)


# Server --------------------

server <- function(input, output, session) {
  
  # Reactive events -----
  
  # Download AZMet data for all stations and for user-specified date range
  dataAZMetDataELT <- eventReactive(input$retrieveData, {
    validate(
      need(expr = input$startDate <= input$endDate, message = FALSE)
    )
    
    idRetrievingData <- showNotification(
      ui = "Retrieving data . . .", 
      action = NULL, 
      duration = NULL, 
      closeButton = FALSE,
      id = "idRetrievingData",
      type = "message"
    )
    
    on.exit(removeNotification(id = idRetrievingData), add = TRUE)
    
    fxnAZMetDataELT(
      azmetStation = NULL, 
      startDate = input$startDate, 
      endDate = input$endDate
    )
  })
  
  # Outputs -----
  
  scatterplot <- shiny::reactive({
    fxnScatterplot(
      inData = dataAZMetDataELT(),
      azmetStation = input$azmetStation,
      batteryVariable = input$batteryVariable,
      weatherVariable = input$weatherVariable
    )
  })
  
  timeSeries <- shiny::reactive({
    fxnTimeSeries(
      inData = dataAZMetDataELT(),
      azmetStation = input$azmetStation,
      batteryVariable = input$batteryVariable,
      weatherVariable = input$weatherVariable
    )
  })
  
  output$scatterplot <- plotly::renderPlotly(scatterplot())
  output$timeSeries <- plotly::renderPlotly(timeSeries())
}

# Run --------------------

shinyApp(ui = ui, server = server)
