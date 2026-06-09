# Explore graphs that compare battery voltage with weather variables by station


# UI --------------------


ui <- 
  htmltools::htmlTemplate(
    filename = "azmet-shiny-template.html",
    
    pageSidebarBatteryVoltageViewer = 
      bslib::page_sidebar(
        title = NULL,
        sidebar = pageSidebar, # `scr##_pageSidebar.R`
        theme = theme, # `scr##_theme.R`
        
        bslib::page_sidebar(
          sidebar = navsetCardTabSidebar, # `scr##_navsetCardTabSidebar.R`
          navsetCardTab, # `scr##_navsetCardTab.R`
        ),
        
        shiny::htmlOutput(outputId = "figureHelpText"),
        shiny::htmlOutput(outputId = "figureFooter")
      )
    )


# Server --------------------

server <- 
  function(input, output, session) {
    
    
    # Observables -----
    
    shiny::observeEvent(input$retrieveData, {
      if (input$startDate > input$endDate) {
        shiny::showModal(datepickerErrorModal) # `scr##_datepickerErrorModal.R`
      }
    })
    
    
    # Reactives -----
    
    dataAZMetDataELT <- 
      shiny::eventReactive(input$retrieveData, {
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
    
    figureFooter <- 
      shiny::eventReactive(dataAZMetDataELT(), {
        fxnFigureFooter(timeStep = "Daily")
      })
    
    figureHelpText <- 
      shiny::eventReactive(dataAZMetDataELT(), {
        fxnFigureHelpText(
          startDate = input$startDate,
          endDate = input$endDate
        )
      })
    
    scatterplot <- 
      shiny::reactive({
        fxnScatterplot(
          inData = dataAZMetDataELT(),
          azmetStation = input$azmetStation,
          batteryVariable = input$batteryVariable,
          weatherVariable = input$weatherVariable
        )
      })
    
    timeSeries <- 
      shiny::reactive({
        fxnTimeSeries(
          inData = dataAZMetDataELT(),
          azmetStation = input$azmetStation,
          batteryVariable = input$batteryVariable,
          weatherVariable = input$weatherVariable
        )
      })
    
    
    # Outputs -----
    
    output$figureFooter <-
      shiny::renderUI({
        figureFooter()}
      )
    
    output$figureHelpText <- 
      shiny::renderUI({
        figureHelpText()
      })
    
    output$scatterplot <- 
      plotly::renderPlotly(scatterplot())
    
    output$timeSeries <- 
      plotly::renderPlotly(timeSeries())
  }


# Run --------------------


shiny::shinyApp(ui = ui, server = server)
