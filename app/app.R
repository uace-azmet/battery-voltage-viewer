# Shiny app to explore graphs that compare battery voltage with weather variables by AZMet station

# Add code for the following
# 
# 'azmet-shiny-template.html': <!-- Google tag (gtag.js) -->


# Libraries
library(azmetr)
library(bslib)
library(dplyr)
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
#source("./R/scr##_DEF.R", local = TRUE)


# UI --------------------

ui <- htmltools::htmlTemplate(
  
  filename = "azmet-shiny-template.html",
  
  pageSidebar = bslib::page_sidebar(
    title = NULL,
    
    sidebar = sidebar, # `scr04_sidebar.R`
    
    navsetCardTab, # `scr05_navsetCardTab.R`
    
    shiny::htmlOutput(outputId = "figureHelpText"),
    htmltools::br(),
    htmltools::br(),
    htmltools::br(),
    shiny::htmlOutput(outputId = "figureFooter"),
    
    fillable = TRUE,
    fillable_mobile = FALSE,
    theme = theme, # `scr03_theme.R`
    lang = NULL,
    window_title = NA
  )
)


# Server --------------------

server <- function(input, output, session) {
  
  shiny::observeEvent(input$retrieveData, {
    if (input$startDate > input$endDate) {
      shiny::showModal(datepickerErrorModal) # `scr06_datepickerErrorModal.R`
    }
  })
  
  dataAZMetDataELT <- shiny::eventReactive(input$retrieveData, {
    shiny::validate(
      shiny::need(
        expr = input$startDate <= input$endDate,
        message = FALSE
      )
    )
    
    idRetrievingData <- shiny::showNotification(
      ui = "Retrieving data . . .", 
      action = NULL, 
      duration = NULL, 
      closeButton = FALSE,
      id = "idRetrievingData",
      type = "message"
    )
    
    on.exit(shiny::removeNotification(id = idRetrievingData), add = TRUE)
    
    fxnAZMetDataELT(
      azmetStation = NULL, 
      startDate = input$startDate, 
      endDate = input$endDate
    )
  })
  
  figureFooter <- shiny::eventReactive(dataAZMetDataELT(), {
    fxnFigureFooter(timeStep = "Daily")
  })
  
  figureHelpText <- shiny::eventReactive(dataAZMetDataELT(), {
    fxnFigureHelpText(
      startDate = input$startDate,
      endDate = input$endDate
    )
  })
  
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
  
  # Outputs -----
  
  output$figureFooter <- shiny::renderUI({figureFooter()})
  output$figureHelpText <- shiny::renderUI({figureHelpText()})
  output$scatterplot <- plotly::renderPlotly(scatterplot())
  output$timeSeries <- plotly::renderPlotly(timeSeries())
}

# Run --------------------

shiny::shinyApp(ui = ui, server = server)
