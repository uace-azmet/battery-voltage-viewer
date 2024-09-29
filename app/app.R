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
library(parsnip)
library(plotly)
library(shiny)
library(tibble)
#library(tidymodels)
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
    
    shiny::htmlOutput(outputId = "figureHelpText"),
    htmltools::br(),
    htmltools::br(),
    htmltools::br(),
    shiny::htmlOutput(outputId = "figureFooter"),
    
    fillable = TRUE,
    fillable_mobile = FALSE,
    theme = theme,
    lang = NULL,
    window_title = NA
    
    
  )
)


# Server --------------------

server <- function(input, output, session) {
  
  shiny::observeEvent(input$retrieveData, {
    if (input$startDate > input$endDate) {
      shiny::showModal(
        shiny::modalDialog(
          shiny::helpText(em(
            "Please select a 'Start Date' that is earlier than or the same as the 'End Date'."
          )),
          easyClose = FALSE,
          fade = FALSE,
          footer = shiny::modalButton("OK"),
          size = "s",
          title = htmltools::p(bsicons::bs_icon("calendar-event"), " DATE SELECTION")
        )
      )
    }
  })
  
  dataAZMetDataELT <- eventReactive(input$retrieveData, {
    validate(
      need(
        expr = input$startDate <= input$endDate,
        message = FALSE
      )
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

shinyApp(ui = ui, server = server)
