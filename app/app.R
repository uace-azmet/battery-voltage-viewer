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
    
    shiny::observeEvent(input$azmetStationScatterplot, {
      azmetStation(input$azmetStationScatterplot)
      print(azmetStation())
      
      shiny::updateSelectInput(
        inputId = "azmetStationTimeSeries",
        label = "AZMet Station",
        choices = 
          c(
            "Select a station..." = "",
            sort(azmetStationMetadata$meta_station_name)
          ),
        # selected = azmetStationMetadata$meta_station_name[1]
        selected = azmetStation() # Reactive value initialized in `_global.R`
      )
    })

    shiny::observeEvent(input$azmetStationTimeSeries, {
      azmetStation(input$azmetStationTimeSeries)
      print(azmetStation())
      
      shiny::updateSelectInput(
        inputId = "azmetStationScatterplot",
        label = "AZMet Station",
        choices = 
          c(
            "Select a station..." = "",
            sort(azmetStationMetadata$meta_station_name)
          ),
        # selected = azmetStationMetadata$meta_station_name[1]
        selected = azmetStation() # Reactive value initialized in `_global.R`
      )
    })
    
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
        shiny::req(azmetStation())
        
        fxnScatterplot(
          inData = dataAZMetDataELT(),
          azmetStation = input$azmetStationScatterplot,
          batteryVariable = input$batteryVariableScatterplot,
          weatherVariable = input$weatherVariableScatterplot
        )
      })
    
    timeSeries <- 
      shiny::reactive({
        shiny::req(azmetStation())
        
        fxnTimeSeries(
          inData = dataAZMetDataELT(),
          azmetStation = input$azmetStationTimeSeries,
          batteryVariable = input$batteryVariableTimeSeries,
          weatherVariable = input$weatherVariableTimeSeries
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
