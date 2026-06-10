# Explore graphs that compare battery voltage with weather variables by station


# UI --------------------


ui <- 
  htmltools::htmlTemplate(
    filename = "azmet-shiny-template.html",
    
    pageBatteryVoltageViewer = 
      bslib::page(
        title = NULL,
        theme = theme, # `scr##_theme.R`
        
        bslib::layout_sidebar(
          sidebar = pageSidebar, # `scr##_pageSidebar.R`
          shiny::uiOutput(outputId = "navsetCardTab")
        ),
        
        shiny::htmlOutput(outputId = "figureHelpText"),
        shiny::htmlOutput(outputId = "pageBottomText") # Common, regardless of card tab
      )
  )


# Server --------------------

server <- 
  function(input, output, session) {
    shinyjs::useShinyjs(html = TRUE)
    # shinyjs::hideElement(id = "navsetCardTabSidebar")
    # shinyjs::hideElement(id = "pageBottomText")
    
    # Observables -----
    
    shiny::observeEvent(input$retrieveData, {
      if (input$startDate > input$endDate) {
        shiny::showModal(datepickerErrorModal) # `scr##_datepickerErrorModal.R`
      }
      
      shinyjs::showElement(id = "navsetCardTab")
      # shinyjs::showElement(id = "navsetCardTabSidebar")
      # shinyjs::showElement(id = "pageBottomText")
      
      showNavsetCardTab(TRUE)
      # showNavsetCardTabSidebar(TRUE)
      # showPageBottomText(TRUE)
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
    
    figureHelpText <- 
      shiny::eventReactive(dataAZMetDataELT(), {
        fxnFigureHelpText(
          startDate = input$startDate,
          endDate = input$endDate
        )
      })
    
    pageBottomText <- 
      shiny::eventReactive(dataAZMetDataELT(), {
        fxnPageBottomText()
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
    
    output$figureHelpText <- 
      shiny::renderUI({
        figureHelpText()
      })
    
    output$navsetCardTab <- 
      shiny::renderUI({
        shiny::req(showNavsetCardTab())
        navsetCardTab # `scr##_navsetCardTab.R`
      })
    
    output$pageBottomText <-
      shiny::renderUI({
        pageBottomText()}
      )
    
    output$scatterplot <- 
      plotly::renderPlotly(scatterplot())
    
    output$timeSeries <- 
      plotly::renderPlotly(timeSeries())
  }


# Run --------------------


shiny::shinyApp(ui = ui, server = server)
